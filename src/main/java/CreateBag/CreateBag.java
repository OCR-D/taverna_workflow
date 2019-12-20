/*
 * Copyright 2018 Karlsruhe Institute of Technology.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package CreateBag;

import com.github.jscancella.conformance.BagLinter;
import com.github.jscancella.conformance.exceptions.BagitVersionIsNotAcceptableException;
import com.github.jscancella.conformance.exceptions.FetchFileNotAllowedException;
import com.github.jscancella.conformance.exceptions.MetatdataValueIsNotAcceptableException;
import com.github.jscancella.conformance.exceptions.MetatdataValueIsNotRepeatableException;
import com.github.jscancella.conformance.exceptions.RequiredManifestNotPresentException;
import com.github.jscancella.conformance.exceptions.RequiredMetadataFieldNotPresentException;
import com.github.jscancella.conformance.exceptions.RequiredTagFileNotPresentException;
import com.github.jscancella.domain.Bag;
import com.github.jscancella.domain.Manifest;
import com.github.jscancella.exceptions.CorruptChecksumException;
import com.github.jscancella.exceptions.FileNotInPayloadDirectoryException;
import com.github.jscancella.exceptions.InvalidBagitFileFormatException;
import com.github.jscancella.exceptions.InvalidPayloadOxumException;
import com.github.jscancella.exceptions.MaliciousPathException;
import com.github.jscancella.exceptions.MissingBagitFileException;
import com.github.jscancella.exceptions.MissingPayloadDirectoryException;
import com.github.jscancella.exceptions.MissingPayloadManifestException;
import com.github.jscancella.exceptions.PayloadOxumDoesNotExistException;
import com.github.jscancella.exceptions.UnparsableVersionException;
import com.github.jscancella.hash.BagitChecksumNameMapping;
import com.github.jscancella.hash.Hasher;
import com.github.jscancella.hash.StandardHasher;
import com.github.jscancella.reader.BagReader;
import com.github.jscancella.verify.BagVerifier;
import com.github.jscancella.writer.BagWriter;
import com.github.jscancella.writer.internal.BagCreator;
import com.github.jscancella.writer.internal.CreateTagManifestsVistor;
import com.github.jscancella.writer.internal.ManifestWriter;
import com.github.jscancella.writer.internal.MetadataWriter;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import net.lingala.zip4j.ZipFile;
import net.lingala.zip4j.model.ZipParameters;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Utility handling BagIt containers.
 */
public class CreateBag {

  /**
   * Logger.
   */
  private static final Logger LOGGER = LoggerFactory.getLogger(CreateBag.class);
  /**
   * Error message multiple OCR-D identifier
   */
  public static final String MULTIPLE_OCR_D_IDENTIFIER = "Error: Multiple OCRD identifiers defined!";
  /**
   * Error message multiple OCR-D identifier
   */
  public static final String MULTIPLE_METS_LOCATIONS = "Error: Multiple METS locations defined!";
  /**
   * Key inside Bagit container defining OCRD identifier.
   */
  public static final String X_OCRD_IDENTIFIER = "Ocrd-Identifier";
  /**
   * Key inside Bagit container defining location of the METS file.
   */
  public static final String X_OCRD_METS = "Ocrd-Mets";
  /**
   * Default location of the METS file.
   */
  public static final String BAG_SOFTWARE_AGENT = "Bag-Software-Agent";
  /**
   * Default location of the METS file.
   */
  public static final String METS_LOCATION_DEFAULT = "data/mets.xml";
  /**
   * Key for profiler file.
   */
  public static final String PROFILE_IDENTIFIER = "BagIt-Profile-Identifier";
  /**
   * Default location of profiler.
   */
  public static final String PROFILE_IDENTIFIER_LOCATION = "https://ocr-d.github.io/bagit-profile.json";
  /**
   * Manifestation Depth
   */
  public static final String OCRD_MANIFESTATION = "Ocrd-Manifestation-Depth";
  /**
   * Default location of profiler.
   */
  public static final String OCRD_MANIFESTATION_DEFAULT = "partial";

  /**
   * Build BagIt container of a payload directory.
   *
   * @param payLoadPath Path to payload directory.
   * @param pathToMetadataDir Path to metadata directory.
   * @param ocrdIdentifier OCR-D Identifier of the bag.
   *
   * @return Bag of directory.
   * @throws Exception Error building bag.
   */
  public static Bag buildBag(final File payLoadPath, final File pathToMetadataDir, final String ocrdIdentifier) throws Exception {
    Bag bag = null;
    try {
      Path folder = Paths.get(payLoadPath.getAbsolutePath());
      List<String> algorithms = Arrays.asList(StandardHasher.SHA512.getBagitAlgorithmName());
      boolean includeHiddenFiles = false;
      bag = BagCreator.bagInPlace(folder, algorithms, includeHiddenFiles);
      bag.getMetadata().add(X_OCRD_IDENTIFIER, ocrdIdentifier);
      bag.getMetadata().add(PROFILE_IDENTIFIER, PROFILE_IDENTIFIER_LOCATION);
      bag.getMetadata().add(X_OCRD_METS, METS_LOCATION_DEFAULT);
      bag.getMetadata().add(OCRD_MANIFESTATION, OCRD_MANIFESTATION_DEFAULT);
      String softwareAgent = String.format("CreateBag %s from path '%s' with identifier '%s'",
              new CreateBag().getClass().getPackage().getImplementationVersion(), payLoadPath.getPath(), ocrdIdentifier);
      bag.getMetadata().add(BAG_SOFTWARE_AGENT, softwareAgent);
      addTagDirectory(bag, pathToMetadataDir);
    } catch (NoSuchAlgorithmException | IOException ex) {
      LOGGER.error("Can't create Bag!", ex);
      throw new Exception(ex.getMessage());
    }
    return bag;
  }

  /**
   * Build BagIt container of a payload directory.
   *
   * @param payLoadPath Path to payload directory.
   *
   * @return Bag of directory.
   * @throws Exception Error building bag.
   */
  public static Bag buildBag(final File payLoadPath) throws Exception {
    return buildBag(payLoadPath, UUID.randomUUID().toString());
  }

  /**
   * Build BagIt container of a payload directory.
   *
   * @param payLoadPath Path to payload directory.
   * @param ocrdIdentifier Identifier for the document.
   *
   * @return Bag of directory.
   * @throws Exception Error building bag.
   */
  public static Bag buildBag(final File payLoadPath, final String ocrdIdentifier) throws Exception {
    return buildBag(payLoadPath, null, ocrdIdentifier);
  }

  /**
   * Creating BagIt container of a bagIt directory.
   *
   * @param pathToBag Path to bagIt directory.
   *
   * @return Bag of directory.
   * @throws Exception Error reading bag.
   */
  public static Bag readBag(final Path pathToBag) throws Exception {
    LOGGER.debug("Read BagIt...");
    Bag bag = null;
    try {
      bag = BagReader.read(pathToBag);
    } catch (IOException | UnparsableVersionException | MaliciousPathException | InvalidBagitFileFormatException ex) {
      LOGGER.error("Can't read Bag!", ex);
      throw new Exception(ex.getMessage());
    }
    validateBagit(bag);

    return bag;
  }

  /**
   * Validate BagIt container.
   *
   * @param bag Bag to validate.
   *
   * @return true or false
   * @throws Exception Error validating bag.
   */
  public static boolean validateBagit(final Bag bag) throws Exception {
    boolean valid = true;
    LOGGER.debug("Validate Bag!");
    try {
      BagVerifier.quicklyVerify(bag);
    } catch (IOException | InvalidPayloadOxumException | PayloadOxumDoesNotExistException ex) {
      LOGGER.error("PayLoadOxum is invalid: ", ex);
      throw new Exception(ex.getMessage());
    }
    /////////////////////////////////////////////////////////////////
    // Check for Profile and validate it
    /////////////////////////////////////////////////////////////////
    List<String> url2Profile = bag.getMetadata().get("BagIt-Profile-Identifier");
    Iterator<String> profileIterator = url2Profile.iterator();
    try {
      if (profileIterator.hasNext()) {
        InputStream inputStream4Profile = new URL(profileIterator.next()).openStream();
        BagLinter.checkAgainstProfile(inputStream4Profile, bag);
      }
    } catch (BagitVersionIsNotAcceptableException | FetchFileNotAllowedException | MetatdataValueIsNotAcceptableException | MetatdataValueIsNotRepeatableException | RequiredManifestNotPresentException | RequiredMetadataFieldNotPresentException | RequiredTagFileNotPresentException | IOException ex) {
      LOGGER.error("Container does not match the defined profile!", ex);
      throw new Exception(ex.getMessage());
    }
    /////////////////////////////////////////////////////////////////
    // Verify completeness
    /////////////////////////////////////////////////////////////////
    boolean ignoreHiddenFiles = false;
    try {
      BagVerifier.isComplete(bag, ignoreHiddenFiles);
    } catch (IOException | MissingPayloadManifestException | MissingBagitFileException | MissingPayloadDirectoryException | FileNotInPayloadDirectoryException | MaliciousPathException | InvalidBagitFileFormatException ex) {
      LOGGER.error("Bag is not complete!", ex);
      throw new Exception(ex.getMessage());
    }
    /////////////////////////////////////////////////////////////////
    // Verify validity
    /////////////////////////////////////////////////////////////////
    try {
      BagVerifier.isValid(bag, ignoreHiddenFiles);
    } catch (IOException | MissingPayloadManifestException | MissingBagitFileException | MissingPayloadDirectoryException | FileNotInPayloadDirectoryException | MaliciousPathException | CorruptChecksumException | InvalidBagitFileFormatException | NoSuchAlgorithmException ex) {
      LOGGER.error("Bag is not valid!", ex);
      throw new Exception(ex.getMessage());
    }
    printBagItInformation(bag);
    return valid;
  }

  /**
   * Print some information about the BagIt container.
   *
   * @param bag Instance holding BagIt container.
   */
  public static void printBagItInformation(final Bag bag) {
    if (LOGGER.isDebugEnabled()) {
      LOGGER.debug("Version: {}", bag.getVersion());
      bag.getMetadata().getAll().forEach((entry) -> {
        LOGGER.debug("{} : {}", entry.getKey(), entry.getValue());
      });
    }
  }

  /**
   * Determines the path to the METS file.
   *
   * @param bag BagIt container.
   *
   * @return Relative path to METS file.
   */
  public static String getPathToMets(final Bag bag) throws Exception {
    List<String> listOfEntries = bag.getMetadata().get(X_OCRD_METS);
    String pathToMets = METS_LOCATION_DEFAULT;
    if (listOfEntries != null) {
      if (listOfEntries.size() > 1) {
        LOGGER.error("There are multiple location for METS defined!");
        for (String item : listOfEntries) {
          LOGGER.warn("Found: {}", item);
        }
        throw new Exception(MULTIPLE_METS_LOCATIONS);
      }
      pathToMets = listOfEntries.get(0);
    }
    LOGGER.trace("Path to METS: {}", pathToMets);
    return pathToMets;
  }

  /**
   * Determines the path to the METS file.
   *
   * @param bag BagIt container.
   *
   * @return Relative path to METS file.
   */
  public static String getOcrdIdentifierOfBag(final Bag bag) throws Exception {
    List<String> listOfEntries = bag.getMetadata().get(X_OCRD_IDENTIFIER);
    String ocrdIdentifier = null;
    if (listOfEntries != null) {
      if (listOfEntries.size() > 1) {
        LOGGER.error("There are multiple OCRD identifiers defined!");
        for (String item : listOfEntries) {
          LOGGER.warn("Found: {}", item);
        }
        throw new Exception(MULTIPLE_OCR_D_IDENTIFIER);
      }
      ocrdIdentifier = listOfEntries.get(0);
    }
    LOGGER.trace("OCRD identifier: {}", ocrdIdentifier);
    return ocrdIdentifier;
  }

  /**
   * Add a directory to bag as tag directory.Copy directory in bag.
   *
   *
   * @param bag Bag
   * @param tagDirectory directory to add.
   * @throws java.security.NoSuchAlgorithmException Unsupported algorithm for
   * checksum
   * @throws java.io.IOException Error reading/writing on disc.
   */
  public static void addTagDirectory(Bag bag, final File tagDirectory) throws NoSuchAlgorithmException, IOException {
    Path bagitRootPath = bag.getRootDir();
    if (tagDirectory != null) {
      LOGGER.trace("addTagDir '{}' to bag '{}'", tagDirectory.getPath(), bag.getRootDir().toString());

      FileUtils.copyDirectory(tagDirectory, Paths.get(bagitRootPath.toString(), tagDirectory.getName()).toFile());
    }
    boolean includeHiddenFiles = false;
    List<String> algorithms = new ArrayList<>();
    for (Manifest manifest : bag.getPayLoadManifests()) {
      algorithms.add(manifest.getBagitAlgorithmName());
    }
    final Map<Manifest, Hasher> tagFilesMap = new ConcurrentHashMap<>();

    for (final String algorithm : algorithms) {
      final Manifest manifest = new Manifest(algorithm);
      final Hasher hasher = BagitChecksumNameMapping.get(algorithm);
      tagFilesMap.put(manifest, hasher);
    }
    final CreateTagManifestsVistor tagVistor = new CreateTagManifestsVistor(tagFilesMap, includeHiddenFiles);
    Files.walkFileTree(bagitRootPath, tagVistor);
    // Remove all tagmanifest... files. They are not allowed in tagmanifest files.
    for (Manifest key : tagFilesMap.keySet()) {
      Set<Path> removeFromFileToChecksumMap = new HashSet<>();
      Map<Path, String> fileToChecksumMap = key.getFileToChecksumMap();
      for (Path item : fileToChecksumMap.keySet()) {
        if (item.toString().startsWith(Paths.get(bagitRootPath.toString(), "tagmanifest-").toString())) {
          removeFromFileToChecksumMap.add(item);
        }
      }
      for (Path removeItem : removeFromFileToChecksumMap) {
        fileToChecksumMap.remove(removeItem);
      }
    }
    // Clear existing tag manifests first.
    bag.getTagManifests().clear();
    // Add the new ones.
    bag.getTagManifests().addAll(tagFilesMap.keySet());
    ManifestWriter.writePayloadManifests(bag.getPayLoadManifests(), bag.getRootDir(), bag.getRootDir(), bag.getFileEncoding());
    MetadataWriter.writeBagMetadata(bag.getMetadata(), bag.getVersion(), bag.getRootDir(), bag.getFileEncoding());
    ManifestWriter.writeTagManifests(bag.getTagManifests(), bag.getRootDir(), bag.getRootDir(), bag.getFileEncoding());
  }

  /**
   * @param args the command line arguments
   */
  public static void main(String[] args) {
    for (String arg : args) {
      LOGGER.debug("javaArgument " + arg);
    }
    if (args.length < 3) {
      System.err.println("Wrong number of arguments!");
      System.err.println("Usage:\n CreateBag dataDir identifier ocrdIdentifier!");
    }
    String dataDirectory = args[0];
    String identifier = args[1];
    String ocrdIdentifier = args[2];
    try {
      File metadataDirectory = Paths.get(dataDirectory, "metadata").toFile();
      if (metadataDirectory.exists()) {
        LOGGER.debug("Director exists: " + metadataDirectory.toString());
        // Test for ocrd.zip file
        File ocrdZipFile = Paths.get(dataDirectory,"taverna_" + identifier + ".ocrd.zip").toFile();
        if (ocrdZipFile.exists()) {
          LOGGER.debug("ocrd.zip exists: " + ocrdZipFile.toString());
          // Create temp directory
          Path tempDirWithPrefix = Files.createTempDirectory("ocrdZip");
          // Extract zip file to temp directory
          ZipFile zipFile = new ZipFile(ocrdZipFile);
          zipFile.extractAll(tempDirWithPrefix.toString());
          // Test if metadata directory already exists
          if (!Paths.get(tempDirWithPrefix.toString(), "metadata").toFile().exists()) {
            LOGGER.debug("No metadata exists --> add metadata");
            // Add metadata directory to zip file
            // Make backup from zip
            LOGGER.debug("Backup file to path: " + Paths.get(ocrdZipFile.getParent(), FilenameUtils.getBaseName(ocrdZipFile.getName()) + "_withoutMetadata.ocrd.zip").toString());
            FileUtils.copyFile(ocrdZipFile, Paths.get(ocrdZipFile.getParent(), FilenameUtils.getBaseName(ocrdZipFile.getName()) + "_withoutMetadata.ocrd.zip").toFile());
            
            // Read bag
            Bag ocrdBag = BagReader.read(tempDirWithPrefix);
            // Add metadata directory to bag
            CreateBag.addTagDirectory(ocrdBag, metadataDirectory);
            // Write bag to temp directory
            BagWriter.write(ocrdBag, tempDirWithPrefix);
            // Update existing zip filels
            ZipParameters parameters = new ZipParameters();
            parameters.setIncludeRootFolder(false);
            LOGGER.debug("Add folder");
            zipFile.addFolder(tempDirWithPrefix.toFile(), parameters);
          }
          // Clean up (remove temp directory)
          FileUtils.deleteDirectory(tempDirWithPrefix.toFile());
        }
      }
    } catch (IOException | UnparsableVersionException | InvalidBagitFileFormatException | MaliciousPathException | NoSuchAlgorithmException ex) {
      String message = "Error while creating bag with metadata!";
      LOGGER.error(message, ex);
      System.err.println(message + " - " + ex.getMessage());
    }
  }

}

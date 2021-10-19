// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use.
  string baseSvg1 = "<svg preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350' xmlns='http://www.w3.org/2000/svg'><style>.base { font-size:28px;font-family:serif;dominant-baseline:middle;text-anchor:middle;fill:#ffffff }</style><rect y='1.306' width='100%' height='100%' fill='";
  string baseSvg2 = "' /><text class='base' x='180' y='230' dominant-baseline='middle'>";
  string baseSvg3 = "</text><g transform='translate(1.306 -26.772)' stroke='#fff' stroke-width='1.5'><path d='m166.83 217.9c-32.891-4.6174-58.136-30.938-60.411-62.986-2.1795-30.708 17.43-59.151 47.677-69.153 27.192-8.9924 57.611-1.1562 76.334 19.664 14.774 16.429 20.571 37.859 15.992 59.118-1.615 7.4976-5.4841 16.518-9.76 22.754-11.639 16.974-28.988 27.697-49.512 30.601-4.7667 0.67449-15.523 0.67559-20.321 2e-3zm17.259-4.3873c13.606-1.4615 26.648-7.002 36.743-15.609 2.9448-2.5108 8.0502-7.8415 8.0515-8.4067 3.1e-4 -0.14519-7.4516-0.26399-16.56-0.26399h-16.56l-14.051-9.91 0.0149-27.164 0.0149-27.164 13.993-10.032h16.165l6.9271 4.9222 1.1911-2.3731 1.1911-2.3731 10.71-0.35199-1.9359-2.4639c-4.5899-5.8418-9.5138-10.36-15.831-14.526-14.793-9.7558-33.063-13.186-51.023-9.5794-12.229 2.4558-24.833 9.2089-33.58 17.992-2.1911 2.2001-7.0776 8.0446-7.0776 8.4651 0 0.15827 8.8212 0.28776 19.603 0.28776h19.603l14.183 10.202v54.072l-14.078 9.8198-36.815 0.35199 2.6325 2.9273c8.3753 9.3133 20.712 16.562 33.336 19.586 7.5203 1.8016 15.857 2.3744 23.153 1.5907zm-61.995-54.287-0.0132-25.783-3.2945-2.1999c-1.812-1.21-3.4383-2.1999-3.6141-2.1999-0.56996 0-2.365 6.208-3.3586 11.616-0.64519 3.5114-0.64481 15.851 7.3e-4 19.359 0.79471 4.3198 2.1556 9.2098 3.5232 12.659 1.6814 4.2414 5.9993 12.332 6.5814 12.332 0.10352 0 0.18226-11.602 0.17498-25.783zm114.64 18.286c4.0712-8.414 6.411-18.331 6.411-27.174 0-5.9331-1.5935-15.083-3.5862-20.593-1.0361-2.8646-3.4134-8.094-3.6796-8.094-0.12716 0-0.97332 4.633-1.8804 10.296l-1.6492 10.296-16.63 0.1892v-10.925h-9.6903c-5.8726 0-9.6903 0.13167-9.6903 0.33421 0 0.18381 1.0696 1.0689 2.3769 1.9668l2.3769 1.6326 8e-3 16.072c9e-3 18.091-0.0102 17.952 2.7562 19.985 1.3522 0.9938 1.4911 1.0175 6.6219 1.1291l5.2407 0.11396v-9.9076h18.284v9.758c0 11.09-0.13604 10.845 2.7308 4.92zm-83.341-6.0631c2.8412-2.2156 2.7488-1.5313 2.638-19.553l-0.0986-16.042-0.9079-1.275c-0.49934-0.70125-1.5689-1.6398-2.3769-2.0857-1.3766-0.75977-1.9344-0.81823-8.8738-0.93001-4.0727-0.0656-7.4022 0.0136-7.3989 0.17599 3e-3 0.1624 1.1551 1.072 2.5597 2.0213l2.5538 1.726v37.254l5.2696-0.11396c5.2446-0.11343 5.2761-0.11901 6.635-1.1787z' stroke='#fff' stroke-width='1.5' connector-curvature='0'/></g><text x='30' y='330' dominant-baseline='middle' fill='#ffffff' font-family='serif' font-size='24px' text-anchor='middle' xml:space='preserve'>#";
  
 
  // I create three arrays, each with their own theme of random words.
  // Pick some random funny words, names of anime characters, foods you like, whatever! 
  string[] firstWords = ["Superman", "Batman", "Wonderwoman", "Flash", "Aquaman", "Greenlantern"];
  string[] secondWords = ["Underwear", "Sexy", "Naked", "Water", "Black", "Dark"];
  string[] thirdWords = ["Outsider", "Longhair", "Pants", "Master", "Speed", "Light"];
  string[] boxColor = ["black", "indigo", "darkslateblue", "firebrick", "darkolivegreen", "darkgreen", "dimgray"];

  event NewEpicNFTMinted(address sender, uint256 tokenId);

  uint256 totalMinted;

  constructor() ERC721 ("SquareNFT", "SQUARE") {
    console.log("An Epic NFTs, go get rock and wearing underwear!");
  }

  // I create a function to randomly pick a word from each array.
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function pickRandomBoxColor(uint256 tokenId) public view returns (string memory) {
  	uint256 rand = random(string(abi.encodePacked("BOX_COLOR", Strings.toString(tokenId))));
    rand = rand % boxColor.length;
    return boxColor[rand]; 
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeAnEpicNFT() public {
  	require(
  		totalMinted <= 50, 
  		"maximum number of NFTs has been reach!"
  	);

    uint256 newItemId = _tokenIds.current();

    // We go and randomly grab one word from each of the three arrays.
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));
    string memory color = pickRandomBoxColor(newItemId);
    string memory id = Strings.toString(newItemId); 

    // I concatenate it all together, and then close the <text> and <svg> tags.
    string memory finalSvg = string(abi.encodePacked(baseSvg1, color, baseSvg2, combinedWord, baseSvg3, id, "</text></svg>"));

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
  
    // Set the token URI now
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    totalMinted += 1;

    emit NewEpicNFTMinted(msg.sender, newItemId);
  }

  function getTotalNFTsMintedSoFar() public view returns (uint256) {
  	return totalMinted;
  }
}
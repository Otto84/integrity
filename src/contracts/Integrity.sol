pragma solidity ^0.6.0;

///@dev use Ownable contracts for change the onership of the contract or renounce
import "@openzeppelin/contracts/access/Ownable.sol";

///@title 'Integrity' - a decentralized drop box service (the title is due to the security of the integrity data inside a hashing and/or blockchain mixed togheter)
///@author Ottavio Calabrese
///@notice You can use this service for transfer or share files through the blockchain and IPFS

contract Integrity is Ownable {

  // state variable
  string public name = 'Integrity';
  address payable admin;
  bool isActive = true;

  ///@dev fileCount is setting to zero by default
  uint public fileCount = 0;

  //mapping
  mapping(uint => File) public files;

  // struct of the file that can be uploaded
  struct File {
    uint fileId;
    string fileHash;
    uint fileSize;
    string fileType;
    string fileName;
    string fileDescription;
    uint uploadTime;
    address payable uploader;
  }

  //event
  event FileUploaded(
    uint fileId,
    string fileHash,
    uint fileSize,
    string fileType,
    string fileName,
    string fileDescription,
    uint uploadTime,
    address payable uploader
  );

  //constructor
  constructor()  public {
     admin = msg.sender;
  }


  ///@dev here you can find the circuit breaker
 function circuitBraker() external {
     require(admin == msg.sender);
     isActive = !isActive;
 }

  ///@notice this function allow to upload a file inside a dropbox
  ///        and add some require statement explained one by one
  ///@dev i did insert here the modifier at the end of the code
  function uploadFile(string memory _fileHash, uint _fileSize, string memory _fileType, string memory _fileName, string memory _fileDescription) public contractIsActive() {
    // Make sure the file hash exists
    require(bytes(_fileHash).length > 0);
    // Make sure file type exists
    require(bytes(_fileType).length > 0);
    // Make sure file description exists
    require(bytes(_fileDescription).length > 0);
    // Make sure file fileName exists
    require(bytes(_fileName).length > 0);
    // Make sure uploader address exists
    require(msg.sender!=address(0));
    // Make sure file size is more than 0
    require(_fileSize>0);


    // Increment file id setted to 0 by default
    fileCount ++;

    // Add File to the contract
    files[fileCount] = File(fileCount, _fileHash, _fileSize, _fileType, _fileName, _fileDescription, now, msg.sender);
    // Trigger an event
    emit FileUploaded(fileCount, _fileHash, _fileSize, _fileType, _fileName, _fileDescription, now, msg.sender);
  }

  //@dev modifier for check if the isActive is setted on true, and in that case go ahead with the function
  modifier contractIsActive() {
      require(isActive == true);
      _;
  }

  ///@notice self destruct function
  ///@dev call this function to kill the contract
  function kill() public {
    selfdestruct(admin);
 }
}

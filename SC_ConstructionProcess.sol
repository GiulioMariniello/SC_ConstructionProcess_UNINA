pragma solidity 0.5.5;
contract Bcl {
// Defining the structure Transmission
struct Transmission{
address Sender;
address Recipient;
bytes32 FileName;
bytes32 DocType;
uint mineTime;
uint blockNumber;
bytes32 FileHash;
bool Current_version;
bytes32 FileHash_New;
}
bytes32 constant public NULL = "";
//Defining a array with the list of transmitted hashes 
bytes32[] public ListdocHash;
// Defining the structure map to store the docHashes in order to have 
//an accesskey to the Transmission
mapping (bytes32 => Transmission) public docHashes;
//Add transmission function
function Add_transmission (bytes32 _FileName,bytes32 _FileType,
bool _NewVersion, address _Recipient, bytes32 _FileHash, 
bytes32 _OldFileHash) public {
// If the submitted file is new
if(_NewVersion == true) { // if else statement
//Add new transmission
Transmission memory newTransmission =Transmission (msg.sender,_Recipient,
_FileName, _FileType,block.timestamp, block.number, _FileHash, true, NULL);
docHashes[_FileHash] = newTransmission;
ListdocHash.push(_FileHash);
} else {
//If it is a revision: Update the old version
if (docHashes[_OldFileHash].Sender == msg.sender){
docHashes[_OldFileHash].Current_version = false;
docHashes[_OldFileHash].FileHash_New = _FileHash;
Transmission memory newTransmission =Transmission (msg.sender,_Recipient, 
_FileName, _FileType, block.timestamp, block.number,_FileHash, false, _OldFileHash);
docHashes[_FileHash] = newTransmission;
ListdocHash.push(_FileHash);
}}
}
//Return transmission register function
function Return_reg()
public view
returns (address[] memory, bytes32[] memory, bytes32[] memory, uint[] memory, 
uint[] memory, bytes32[] memory, bool[] memory) {
uint inum = ListdocHash.length;   
//Initialisation of vectors 
address[] memory Senders = new address[](inum);
bytes32[] memory FileNames = new bytes32[](inum);
bytes32[] memory DocTypes = new bytes32[](inum);
uint[] memory mineTimes = new uint[](inum);
uint[] memory blockNumbers = new uint[](inum);
bytes32[] memory FileHashs = new bytes32[](inum);
bool[] memory LstVers = new bool[](inum);
//Cycling through all the values I have on the hash list
for (uint i = 0; i < inum ||i < 20; i++) {
Senders[i]=docHashes[ListdocHash[i]].Sender;
FileNames[i] = docHashes[ListdocHash[i]].FileName;
DocTypes[i] = docHashes[ListdocHash[i]].DocType;
mineTimes[i] = docHashes[ListdocHash[i]].mineTime;
blockNumbers[i] = docHashes[ListdocHash[i]].blockNumber;
FileHashs[i] = docHashes[ListdocHash[i]].FileHash;
LstVers[i] = docHashes[ListdocHash[i]].Current_version;
}
//Returning the Register of transmissions
return (Senders, FileNames, DocTypes, mineTimes, blockNumbers, FileHashs,LstVers);
}
function Check_trans (bytes32 TdocHashes) public view returns(address,bytes32,
bytes32,uint, uint,bytes32){
if((docHashes[TdocHashes].Recipient == msg.sender ||
docHashes[TdocHashes].Sender == msg.sender) &&
docHashes[TdocHashes].Current_version == true ){
return
(docHashes[TdocHashes].Sender,docHashes[TdocHashes].FileName,docHashes[TdocHashes].DocType, docHashes[TdocHashes].mineTime,
docHashes[TdocHashes].blockNumber, docHashes[TdocHashes].FileHash);
}
}
}

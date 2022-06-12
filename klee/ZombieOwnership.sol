pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";
import "./erc721.sol";

// erc721 contract, 
// same standard. 
// function: ownerof, 
// in lesson 4, we're using the modifier, ownerof, zombiefeeding.sol
// refactor our code from lesson 4, to change the name of the modifier

// zombiefeeding.sol, change the modifier name,
// to 'onlyOnwerof',  feedAndMultiply, which uses this modifier. We'll need to change the name here as well.
// zombiehelper.sol and zombieattack.sol, b



contract ZombieOwnership is ZombieAttack, ERC721 {

  function balanceOf(address _owner) external view returns (uint256) {
    // 1. Return the number of zombies `_owner` has here
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    // 2. Return the owner of `_tokenId` here
    return zombieToOwner[_tokenId];
  }

  // ch5, transfer logic
  // Define _transfer() here
  // private function
  // 2 mappings when ownership changes,
  // ownerzombiecount: keeps track how many zombies an owner has 
  // zombietoowner: keeps track who owns what 
  // contract 한번 배포되면, 계약마다 저장된 데이터 들이 다 다른데, 그걸 어떻게 가져오나? 

  function _transfer (address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to]++; // _to = 받는 사람 주소 , _to=parameter, 좀비 올라간다
    ownerZombieCount[_from]--; // _from = 주는 사람 주소
    zombieToOwner[_tokenId] = _to; // 그 좀비의 오너가 _to 주소 오너로 바귄다 
    emit Transfer(_from, _to, _tokenId); // 이벤트 배포 
  } 


  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {

  }

  function approve(address _approved, uint256 _tokenId) external payable {

  }
}



/*
//erc721 contract
Note that the ERC721 spec has 2 different ways to transfer tokens:

1/
function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

The first way is the token's owner calls transferFrom with his address as the _from parameter, 
the address he wants to transfer to as the _to parameter, and the _tokenId of the token he wants to transfer.



2/
function approve(address _approved, uint256 _tokenId) external payable;

function transferFrom(address _from, address _to, uint256 _tokenId) external payable;


The second way is the token's owner first calls approve with the address he wants to transfer to, 
and the _tokenID . The contract then stores who is approved to take a token, 
usually in a mapping (uint256 => address). 
Then, when the owner or the approved address calls transferFrom, 
the contract checks if that msg.sender is the owner or is approved by the owner to take the token, and if so it transfers the token to him.


Notice that both methods contain the same transfer logic. In one case the sender of the token calls the transferFrom function; in the other the owner or the approved receiver of the token calls it.

So it makes sense for us to abstract this logic into its own private function, _transfer, which is then called by transferFrom.

*/
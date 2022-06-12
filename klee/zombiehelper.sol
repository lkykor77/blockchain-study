pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  uint levelUpFee = 0.001 ether;

  // Start here
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }
  
    // 1. Create withdraw function here
    // cast _owner (uint160) as Address payable 
    // eth 보낼려면 주소가 address payable 타잎 이여야 한다
    // 그다음 transfer function. address(this).balance = total balance stored on the contract
    // 만약 buyer 가 overpay 했으면, msg.sender.transfer(msg.value - itemFee);

  function withdraw() external onlyOwner {
    address payable _owner = address(uint160(owner()));
    _owner.transfer(address(this).balance);

  }

  // 2. Create setLevelUpFee function here
  // 0.001 eth, eth 가격이 미래에 오른다면 게임이 너무 비싸다. 
  // 내가 owner of the contract 로 만들기. levelupFee 컨트롤하기 위하여
  // 내가 _fee 를 결정한다
  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  // ++ = operator ,연산자, 좀비 구조체 array 안의 내가 원하는 zombie id 의 좀비가 id 레벨 1씩 오른다. 
  function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level++;



  // zombiefactory, mapping (uint => address) public zombieToOwner; _zombieId 가 address
  // calldata = memory, 임시 휘발성, 저장하지 않고. external function 일대만 부른다
  // 매개 변수, 파라미터, 자체가 solidity 안에서 memory 로 판단. 굳이 calldata 안서도 된다.
  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId) {
    //require(msg.sender == zombieToOwner[_zombieId]); modifier ownerOf takes care of it
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId) {
    //require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }

   // Create your function here
   // view function called externally: doesn't create a transaction on the blockchain, so no gas cost. Internally calling does cost 
   // ch11, declaring arrays in memory, Looping over large dataset in external view = free. MEMORY: not write anything in storage. cheaper than updating array in storage
   // view 함수는 데이터를 읽기만 하면 된다. 블록체인에 변화 없이. 가스 비용 안든다. 외부에서 호출하게 되면
   // 내부에서 호출이 된다면, 다른 . view 펑션을 들어가도, a펑션이 가스를 쓴다면 가스가 된다.
    // 각 오너들의 좀비 몇개 가지고 있는지. 좀비들 인덱스 값을 [] 로 메모리 형태로 줘라.
    // 메모리가 휘발성. 리스트를 보여주기 위해, 조회 function 만든다. 
    // 함수 호출할때마다 배열을 memory 에 다시 만든다. 

    // 오너가 가진 좀비카운트 개수만큼 새로운 new uint[] 어레이 메모리로 만들었다.
    // 동적배열,  8장, 구조체와 배열 이용하기. 
    // 배열 개수만큼 만든다. 
    // dynamic memory arrays = uint balance[] = new unit[](size); 
  function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    // 새로운 배열을 만들때 new 를 적어야 한다. 2장, storage vs. memory
    // 변수 저장 공간 storage 영구적 저장되는 변수/memory 
    // 상태변수: 함수 외부에 선언된 변수 초기 설정 storage
    // 함수 내에 선언된 변수는 : memory 로 자동 처리, 함수내에서 구조체, 배열 정리할대
        // 원본을 변경할 필요가 없이, 조회만 하고 싶다. 그래서 메모리로 복사만 한다. 
    
    // ch12. Let's finish our getZombiesByOwner function by writing a for loop that iterates through all the zombies in our DApp, compares their owner to see if we have a match, and pushes them to our result array before returning it.
    //  the function will now return all the zombies owned by _owner without spending any gas.
    // 특정 사용자의 좀비들로 구성된 배열, 

    uint counter = 0;  //use counter to keep track of the index in our result array 
    for (uint i = 0; i < zombies.length; i++) {     // iterate for every zombie in the array
      if (zombieToOwner[i] == _owner) {             // compare the two addresses to see if we have a match
        result[counter] = i;                        // add the zomebie's ID to our result array 
        counter++;                                  // increment counter by 1
      }   
    // 좀비 10개가 있는데 owner 가 1명이다. new array 메모리 배열은 resize 불가능, 10개 좀비 배열로 해야한다.
    // 전체 transfer 사이즈 정해준다. 
    // 좀비 5개, zombies.lengh=5, i=0,1,2,3,4 까지만, 
    // zombietoowner[0] = _owner 라면, 
    // 카운터는 리절트에 대한 인덱스: result[0] = 0;

    /*
    카운터가 왜 들어갔는가? 좀비아이디: 2,3 이 오너가 다르니까. 
    오너 1의 좀비 인덱스가 [0,1,2] 3개 좀비 어레이로 만드려고 
    
    0,1,2,3,4 zombie id
    1,1,2,2,1 zombie owner

    zombie id 0일때
    result[0] = 0
    counter++=> 1
    
    zombie id 1일때
    result[1] = 1
    counter++ => 2

    zombie id 4일때
    result[2] = 4
    counter++ => 3
    result[0,1,2] = zombie ID [0,1,4]
    */

    }
    return result;
  }
    // 소유자가 누군지, getzombiesbyowner, 그들의 소유자가 우리가 찾는 자인지 비교하여 확인한 후, 
    // 조건에 맞는 좀비들을 result 배열에 추가한 후 반환한다. 

    // memory array 는 new operator 로 만들 수 있다. 
    // 이거는 resize memory array 못하니까, push 를 못한다. storage array는 푸시가 된다
    
    // 함수에서 memory array 사용시 new로 생성하고, index 값으로 데이터를 추가하는 이유
    // https:docs.soliditylang.org/en/develop/types.html#allocating-memory-arrays
    // 메모리 배열은 resize가 불가능하기 때문에 size를 지정하여 생성하고 추가로 .push 멤버함수를 사용 못해서,
    // 그래서 인덱스로 데이터를 설정한다.
  }

}


/*
Require 가 있으니까 only owner 먼저 실행 된 후 
Resourceownership 실행 된다. 
그러므로 컨트랙트 오너 만 function call 할 수 있다 

_; 이게 없으면 나머지 function 이 안돌아간다 

펑션:
Our game will have some incentives for people to level up their zombies:
For zombies level 2 and higher, users will be able to change their name.
For zombies level 20 and higher, users will be able to give them custom DNA.

*/

////////////////////////////////////////////////////////////////////////////////
// zombieFeeding contract 
pragma solidity >=0.5.0 <0.6.0;
import "./zombiefactory.sol";

// external : 다른계약에서 호출을 하는 함수. 내부에서는 호출이 불가능. 외부에서만 호출. 
// public: 내부, 외부 다 호출 가능 
// 인터페이스: 우리가 만든게 아니고, 크립토키티에서 만든 함수. 동일하게 적어줘야 한다. getkitty 라는 함수를 이렇게 만들었다. 
// 인터페이스: 
// 기본 함수는 {} 중가로 있다. 이게 function 의 body, 몸체. 다른 계약에서 사용하는 것을 쓰는 인터페이스 만들때는 body 없이 {} 없이 만들어야 된다. 

// 컴파일러가, 이걸 컴퓨터가 알아먹을 수 있게 한다. 

// 리턴하는게 없으면 () 필요없다 
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}
/* 샘플 interface:
contract NumberInterface {
//  function getNum(address _myAddress) public view returns (uint);
}
saved the address of the CryptoKitties contract in the code for you, under a variable named ckAddress. In the next line, create a KittyInterface named kittyContract, and initialize it with ckAddress 

*/

contract ZombieFeeding is ZombieFactory {

// importing zombieFactory contract

      // 1. Remove this:
    // address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    // `ckAddress`를 이용하여 여기에 kittyContract를 초기화한다.

  // 2. Change this to just a declaration:
    // KittyInterface kittyContract = KittyInterface(ckAddress);
    KittyInterface kittyContract

  // adv solidity: ch6,  1. Create modifier here

  // CHANGE THE MODIFIER from 'ownerof' to 'onlyOwnerof'
   modifier onlyOwnerOf(uint _zombieId) {
      require(msg.sender == zombieToOwner[_zombieId]);
      _;
    }

      // 3. Add setKittyContractAddress method here
  //Now we can restrict access to setKittyContractAddress so that no one but us can modify it in the future.
/*
ZombieFeeding is ZombieFactory
ZombieFactory is Ownable
Thus ZombieFeeding is also Ownable, and can access the functions / events / modifiers from the Ownable contract. This applies to any contracts that inherit from ZombieFeeding in the future as well.
*/
  //function setKittyContractAddress(address _address) external {
  function setKittyContractAddress(address _address) external onlyOwner {

    kittyContract = KittyInterface(_address);
  }

  //adv solidity concepts, ch6
  // 구조체를 struct Zombie 를 parameter 로 쓸 수 있다 
  // storage 원본 자체를 가져와서 쓸 수 있다. 
  // Zombie 데이터타이프 구조체, 우리는 무슨 데이터 타잎을 가져올거야 (parameter)로 
  // Zombie에 해당하는 datatype, 원본을 가져온다. internal 우리만 바굴 수 있게
  // _zombie 는 그냥 이름이다. 
  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(now + cooldownTime)
  }

  //adv solidity concepts, ch6
  // define _isready function
  // 하루 전에 생성된 좀비인지 아닌지 true or false 
  // readyTime = now + 1 days 
  // 하루 지난 좀비인지 아닌지. 안에서만 호출 가능 
  // 하루가 지났으면 좀비가 또 feeding kitty 할 수 있다 
  function _isReady(Zombie storage _zombie) internal view returns (bool) {
    return (_zombie.readyTime <= now);
  }

// 리턴은, 값을 사용할대만 필요 
// memory = 템프처럼, db 에 저장 안한다. 메모리에 잠깐 저장 
// 밖에서 이걸 호출할때 뭘 넣지를 모르지만, 만약 kitty 라는 species 있으면, 그 dna 뒤값 99로 명확하게 해주낟. 

// adv solidity concepts, ch7
// make the function internal = contract more secure. don't want users to be able to call this function with any DNA they want
//  // 2. Add modifier to function definition:
          // CHANGE THE NAME 'ownerOf' to 'onlyOwnerof', refactoring, because ERC721 contract uses the name 'ownerof'
    function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal onlyOwnerOf(_zombieId) {
      // 3. Remove this line
    //require(msg.sender == zombieToOwner[_zombieId]);  // zombietoowner (uint->address). 호출자가 이 zombieid, targetdna 값을 넣었을때 그것으로 실행된다 
      Zombie storage myZombie = zombies[_zombieId];     
      // Zombie (구조체, struct) storage, 구조체 이름이 myZombie = zombies 배열 array [808]이면 최소 좀비가 809명있다. 808번째에 있는 내 진짜 좀비를 받는다. 원본을 바꾸고 싶으면 storage로 한다. 
      // myzombie 변수이다.
      // myzombie.dna 가 Zombie 구조체 (name, dna) 로 값이 저장된다

      // require: user can only execute this FEEDmultiply function if a zombie's cooldown time is over(passed 1 day) 
      // _isReady call the function = 호출한다 , myzombie 파라미터 를 해서 return 값이 true/false, 
      // _isReady 가 리턴이 TRUE 값을 주면, require TRUE 값이니, 그 이후 코드들이 돌아간다. false 여도 그 전 코드 돌아간다 
      require(_isReady(myZombie));

    _targetDna = _targetDna % dnaModulus;   // 16 digit 으로 만든다 
    uint newDna = (myZombie.dna + _targetDna) / 2;    // 새로운 dna 값은 내 좀비의 dna 값과 타겟의 평균 

    // Add an if statement here
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {   // string으로 했을때 해쉬값의 _species=="kitty" 일때
      newDna = newDna - newDna % 100 + 99;   // 새로운 dna 뒤에 99 창조. Assume newDna 334455. newDna % 100 = 55. so newDna - (newDna % 100) =334400. Finally add 99 to get 334499.
    }

    _createZombie("NoName", newDna);    //    이 새로운 좀비 이름 "" 해줘서 string name, uint newDna 포멧
  
    // call 'triggercooldown'
    // end of this function. Feeding triggers the zombie's cooldown time (지금부터 1 days cooldown)
    _triggerCooldown(myZombie);
  }
  
  // 밖에서도 호출 가능. 수정 아님. 
  // feedonkitty 함수 호출하는 당사자가 넣어주는 unint 값이 _kittyid
  // multiple assignemnt 

  // kittycontract 는 이 함수 function 바깥에 있는데, 그걸 어떻게 호출 가능한지?
  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    // And modify function call here:
    feedAndMultiply(_zombieId, kittyDna, "kitty");   // 제일 끝이 "kitty" dlek 
  }
}

/*
  // 부모 class는 공통된 부분 (animal, 사람), 자식 subclass는 (cat, 미국/한국인)


  // 좀비오너는 좀비의 오너 가져온다. 만약 내가 이 좀비 안가지고 있는데, 내 주소가 이 특정 좀비의 id를 호출할려고 할때는 에러
  // 내 zombie id = 808.   myzombie = zombies[808]
  // 내 주소는 lee808
  // zombietoOwnerp[809] 면 에러. 두번째 줄로 안간다 
  // storage = 블록체인 상에 영구적으로 저장되는 변수 
  // zombies = 함수 밖에서 선언된 함수들. 불러올 수 있다. 상태변수 = 함수 밖에서 선언, storage 된. 
  // 스토리지 가져오면 (call by reference), 포인터 (스토리지, 메모리를 참조한다, 메모리 시작점이 주소, 거기서부터 다시 value 값을 쓴다)
    // 값 바꿔서 영구적으로 저장하려고 storage 
  // 값을 복사하는 것 (call by value): 여기서는 memory, 똑같은 것 복제해서 가져오면, 생김새는 쌍둥이인데 이름이 다르다. 복제본을 변경하니까 원본변경이 아니다.   


  // feedand multiply FUNCTION 
  // we own this zombie. (don't let other feed my zombie). require msg.sender to = zombie's owner (from zombiefactory contract)
  // use _zombieId, it changed to address of zombie owner.     msg.sender=address 
  // mapping (uint => address) public zombieToOwner;
  // get zombie's DNA: myZombie(name), declare a local Zombie (stored, storage pointer), 
  // Zombie[] public zombies;     zombies is array.  index in this array is _zombieId 
  //    struct Zombie {  //zombie 라는 구조체가 데이터 타이프 가 된다 (string, uint처럼).좀비 설계도는 이걸 무조건 가져야된다,structure


 // define function here
   function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId); // genes is the 10th variable in the getkitty function in kittycontract. genes = kittyDna, calling it. 
    //  function getKitty(uint256 _id), requires kitty's ID
    feedAndMultiply(_zombieId, kittyDna); 
  }
*/

/*
// multiple assignment
function multipleReturns() internal returns(uint a, uint b, uint c) {
  return (1, 2, 3);
}

function getLastReturnValue() external {
  uint c;
  // We can just leave the other fields blank:
  (,,c) = multipleReturns();
}

   // private function 
uint[] numbers;   //'numbers' array
function _addToArray(uint _number) private {
    numbers.push(_number);
}
numbers is dynamic array of 'uint' type
private function '_addtoarray', 
uses _number
pushing _number to that array


private _createzombie. _dna 를 조작 못하게 private으로 한다 
public createrandomzombie: 그냥 다른 함수들을 호출한다 
*/


/*
struct packing to save gas
struct minime {
  uint32 a;
  uint32 b;
  uint c;
}
*/
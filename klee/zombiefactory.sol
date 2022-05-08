//https://cryptozombies.io/en/lesson/1/chapter/2



pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;  //10^16, hat way we can later use the modulus operator % to shorten an integer to 16 digits.
    // adv solidity concepts. ch 5, define cooldowntime. declare 
    uint cooldownTime = 1 days;

    event NewZombie(uint zombieId, string name, uint dna);
    // Declare an event called NewZombie

    struct Zombie {  //zombie 라는 구조체가, variable 모은 것. 데이터 타이프 가 된다 (string, uint처럼).좀비 설계도는 이걸 무조건 가져야된다,structure
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime; // adv solidity, ch4, gas, cluster same 32bit data types together. 
        // readyTime = implement a cooldown timer to limit how often a zombie can feed
        // regular uint costs 256 bits
     } 
    //Structs allow you to create more complicated data types that have multiple properties.
    //state variables are stored permanently in the blockchain

    Zombie[] public zombies;   
    // zombie 구조체의 배열이 zombies, 이것은 zombie를 리턴한다 
    // Zombie 구조체는 (uint dna)있다  

    // zombie 구조체 가져온다.의 array. no fixed size of array. Dynamic array. Making it public. Named zombies. Create new zombie, add them to 'ZOMBIES' array
    // Other contracts would then be able to read from, but not write to, this array
    
    // keep track of the address that owns zombie (public)
    // uint= store and look up zombie based on id
    mapping (uint => address) public zombieToOwner;
    // how many zombies an owner has (not public)
    mapping (address => uint) ownerZombieCount;
    //두개를 연결, 맵핑, dictionary
    // 키가 address 이게 맞다면, 키에 데한 value uint 가져온다 


// solidity 문서, push 했었을때 자동적으로 리턴값이. array 의 length, 첫번째 좀비를 넣는다면 그것은 zombies array 의 length = 1, 1-1=0. 그걸 id로 쓴다
    function _createZombie(string memory _name, uint _dna) internal {                              
            // adv solidity concepts ch 5
            // update the zombies.push line. add 2 more arguments
            // 1 for level, uint32(now+cooldownTime) for readyTime
            // now returns a uint256 by default
            // need to explicitly convert it to a uint32. 여기 안에서 struct 구조체 가져온다.
            // 지금부터 now+1days 60*60*60 초를 더해준다= readytime, 시간 uint32 
            // now = 1970/1/1 부터 초를 다 더해준 값 , ID 에 더해진다
            // 좀비 구조체 생성해서, zombie push 한다.
            uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime))) - 1; 
            zombieToOwner[id] = msg.sender;   // 이미 10개좀비 있는 array에 내것 push 하면
            ownerZombieCount[msg.sender]++;   // 키값이 address(lee), 내것처음이면 나의 ownerZombieCount=1, 다른 사람이 7개 좀비 있다면 7
            emit NewZombie(id, _name, _dna); // id= 좀비 어레이 안의 인덱스 숫자로 가져간다. 내 좀비가 어레이에서 11번째라면 그것의 인덱스는 10
    }
/*
function _createzombie (string_name, uint _dna) internal {
  zombie zombievariable = zombie(_name, _dna, 1, uint(now+cooldowntime)
  
}


               // zombies 배열에 새로운 좀비 넣어주고 
               // 이 새로운 좀비의 id가 배열에서 인덱스-1 숫자로 저장된다 
               // zombietowner 맵핑, id의 호출한 사람의 address를 넣어주면 (msg.sender = 계약호출 당사자 주소를 연결)
               // ownerzomebiecount (키값이 msg.sender, 주소에서 uint 맵핑), 그 주소로 만들어진 좀비 개수가 추가된다. 1명씩 더 
               // 제일 마지막에 event NewZombie(uint zombieId, string name, uint dna); 이벤트가 fire 된다 , 이벤트 실행된다 (아직 이벤트 내용은 없다)

               
               // 원래 private function. 하지만 feedingzombies 계약이 zombiefactory 를 inherit 할대 private function 못 가져온다 
               // internal 은 inherit 할 수 있다.
               // external 은 public과 비슷, 하지만 functions only be called outside the contract. 계약 바
               // 계약 바깥에서만 불릴 수 있다. 안에서는 안되고 
               // ++의미: owerzombiecount[msg.sender] = ownerzombiecount[msg.sender]+1
               // 이것은 = 0+1 로 처리가 된다. 

                // Zombie tempZombie = Zombie(_name, _dna);
                // uint length = zombies.push(tempZombie); 프로그램 내에 리턴값은 array계열의 length값으로 , 맨처음 넣었을때 0-> 1로 length 변한다 
                // 1-1 = 0 이 된다.  
                 
                 //좀비 인스턴스를 만든다. array에다가 푸시 넣어준다
                 // 여기서 zombie = structure. 여기서 만드는 새로운 좀비 person instance를 zombies array에 푸시해준다
                 // 설계도로 만들어진 나온 실체 있는 좀비
                //Zombie person = Zombie(_name, _dna);
                //zombies.push(person);

                 //declaring function , 2 parameters (first one _name, stored in memory)
                 // createZombie is private function so _ added
                 // no one or no other contract can call my contract's function and execute its code
                 // _name = memory 에 저장 , reference type = 호출해온다. 스트링, array, mapping은 원본을 홰손하면 안되니, 그대로 memory 하면, 나중에 초기화한다. 숫자는 그냥 카피해서 가져와서 storage
                 // private은 다른 곳에서 이 함수를 호출하지 못한다 

                 // Emit: !!! 이벤트 트리거, 호출 되었을때 일어나는게 이벤트 함수. 무언가 액션이 발생했을때 의사소통 한다. 호출이 됫다. 
                 // 그 이벤트 호출하면 그 행동양식이 있다. 그 행동양식을 실행하라고 한다 emit, trigger the event. fire the NewZombie event here
                 // id = length of the array. after adding new zombie to the zombies array,
                 // since the first item in an array has index 0, array.push() - 1 will be the index of the zombie we just added. Store the result of zombies.push() - 1 in a uint called id,
                 // 좀비스 배열에 푸시하면, 푸시 함수가 length 값을 리턴 한다. 
                 // 
                 // 에레이 숫자로 변환하면 3, (3명 좀비, id1 id2 id3) 있을때. 그런데, 인덱스는 (0,1,2) 로 간다
                 // 내가 새로 추가한 id3 좀비의 인덱스는 2, 그러니까 1을 빼준다 

                 // msg.sender = global variable available to all functions, = address of the person, 펑션에서 쓰인다 
                 // zombieToOwner mapping: store msg.sender under the ID
                 // increase ownerZombieCount for this msg.sender 

   // function _generateRandomDna(string memory _str) private view returns (uint) {
   // private function _, take one parameter _str stored in memory, return a uint. function view our contract's variables but not modify them=view
 
    function _generateRandomDna(string memory _str) private view returns (uint) {
       uint rand = uint(keccak256(abi.encodePacked(_str))); // unint=data type
       return rand % dnaModulus; 
    }
       // 1,563,729 modulo % 1000 = 729. after dividing by 1000, remainder is 729, 1563이 몫이고, 729가 남는다. 0이 세자리
       // dnaModulus = 10^16. there are sixteen 0s. remainder is sixteen digits.
       // 16자리 랜덤 값을 만들기 위해서 해쉬함수를 썼다 

       // view: _str 가져와서 이 함수의 매개변수는 변화시킨다. 그런데, 다른 값들은 변화 안시킨다. 
       // 함수형 언어. _str 이게 똓값으면. 상태 변화 안한다. 
       // dnamodulus 바꾸지 않는다. 
       // contract 안에 있는 dnamodulus 를 쓰니까 이것은 view
       // view: 이 함수가 상태변수를 사용하는데, 그 상태변수 값을 변경 하지 않는다 (dnamModulus)
       // view 없어도 된다? 

       // pure: 엡이서 어떤 데이터도 접근하지 않는다. 
       // contract 안의 어떤 상태값도 참조하지 않으면 pure, 
       // 그냥 안의 변수들만 사용, 
       // function _multiply(uint a, uint b) private pure returns (uint) {
       //    return a*b; }
    

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name); // function 호출해서 랜덤 int 값 가져온다=randDna
        require(ownerZombieCount[msg.sender] == 0); //각 주소 해당하는 좀비 카운트가 0일 경우에만 
        _createZombie(_name, randDna);   // 이 function 호출해서, event가 fire emit 된다 (emit NewZombie(id, _name, _dna)). 내 좀비의 id값은 인덱스 9 (어레이에서 10번째 좀비라서) 
    }
    //createRandomZombie public function
    // use _generateRandomDna function
    // use _createZombie function

    // require condition: ownerzombiecount[msg.sender] is equal to 0. they need to have 0 zombie before calling this function 
    // if not, it'll throw an error.
    // 변수의 유효범위, scope: _name 은 이 function 안에서만 활용.
}

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
}
// importing zombieFactory contract

      // 1. Remove this:
    // address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    // `ckAddress`를 이용하여 여기에 kittyContract를 초기화한다.

  // 2. Change this to just a declaration:
    // KittyInterface kittyContract = KittyInterface(ckAddress);
    KittyInterface kittyContract

      // 3. Add setKittyContractAddress method here
  function setKittyContractAddress(address _address) external {
    kittyContract = KittyInterface(_address);
  }

// 리턴은, 값을 사용할대만 필요 
// memory = 템프처럼, db 에 저장 안한다. 메모리에 잠깐 저장 
// 밖에서 이걸 호출할때 뭘 넣지를 모르지만, 만약 kitty 라는 species 있으면, 그 dna 뒤값 99로 명확하게 해주낟. 
  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
      require(msg.sender == zombieToOwner[_zombieId]);  // zombietoowner (uint->address). 호출자가 이 zombieid, targetdna 값을 넣었을때 그것으로 실행된다 
      Zombie storage myZombie = zombies[_zombieId]; 
      // Zombie (구조체, struct) storage, 구조체 이름이 myZombie = zombies 배열 array [808]이면 최소 좀비가 809명있다. 808번째에 있는 내 진짜 좀비를 받는다. 원본을 바꾸고 싶으면 storage로 한다. 
      // myzombie 변수이다.
      // myzombie.dna 가 Zombie 구조체 (name, dna) 로 값이 저장된다 
    _targetDna = _targetDna % dnaModulus;   // 16 digit 으로 만든다 
    uint newDna = (myZombie.dna + _targetDna) / 2;    // 새로운 dna 값은 내 좀비의 dna 값과 타겟의 평균 

    // Add an if statement here
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {   // string으로 했을때 해쉬값의 _species=="kitty" 일때
      newDna = newDna - newDna % 100 + 99;   // 새로운 dna 뒤에 99 창조. Assume newDna 334455. newDna % 100 = 55. so newDna - (newDna % 100) =334400. Finally add 99 to get 334499.
    }

    _createZombie("NoName", newDna);    //    이 새로운 좀비 이름 "" 해줘서 string name, uint newDna 포멧
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



// advanced solidity concepts
// chapter 5 time units
uint lastUpdated;

// Set `lastUpdated` to `now`
function updateTimestamp() public {
  lastUpdated = now;
}

// Will return `true` if 5 minutes have passed since `updateTimestamp` was 
// called, `false` if 5 minutes have not passed
function fiveMinutesHavePassed() public view returns (bool) {
  return (now >= (lastUpdated + 5 minutes));
}

*/

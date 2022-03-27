
pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;  //10^16, hat way we can later use the modulus operator % to shorten an integer to 16 digits.

    event NewZombie(uint zombieId, string name, uint dna);
    // Declare an event called NewZombie

    struct Zombie {  //zombie 라는 구조체가, variable 모은 것. 데이터 타이프 가 된다 (string, uint처럼).좀비 설계도는 이걸 무조건 가져야된다,structure
        string name;
        uint dna;
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


    function _createZombie(string memory _name, uint _dna) internal {                              
            uint id = zombies.push(Zombie(_name, _dna)) - 1; 
            zombieToOwner[id] = msg.sender;   // 이미 10개좀비 있는 array에 내것 push 하면
            ownerZombieCount[msg.sender]++;   // 키값이 address(lee), 내것처음이면 나의 ownerZombieCount=1, 다른 사람이 7개 좀비 있다면 7
            emit NewZombie(id, _name, _dna); // id= 좀비 어레이 안의 인덱스 숫자로 가져간다. 내 좀비가 어레이에서 11번째라면 그것의 인덱스는 10
    }
    
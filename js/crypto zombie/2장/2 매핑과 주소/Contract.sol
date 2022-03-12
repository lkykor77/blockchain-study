pragma solidity ^0.4.19;

contract ZombieFactory {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie (string _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        NewZombie(id, _name, _dna);
    }

    function _generateRandomDna (string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}

/**
좀비 소유권을 저장하기 위해 2가지 매핑을 이용하고자 하네: 
하나는 좀비 소유자의 주소를 추적하기 위한 것이고, 
다른 하나는 소유한 좀비의 숫자를 추적하기 위한 것이네.

1. zombieToOwner라는 매핑을 생성한다. 
키는 uint이고 (좀비 ID로 좀비를 저장하고 검색할 것이다), 
값은 address이다. 이 매핑을 public으로 설정하자.

2. ownerZombieCount라는 매핑을 생성한다. 
키는 address이고 값은 uint이다.
 */
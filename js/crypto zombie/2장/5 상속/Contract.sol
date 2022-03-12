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
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    function _generateRandomDna (string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}

contract ZombieFeeding is ZombieFactory {
    
}

/**
다음 챕터에서 우리 좀비들이 먹이를 먹고 번식하도록 하는 기능을 구현할 것일세.
그 기능의 로직을 ZombieFactory의 모든 메소드를 상속하는 클래스에 넣어 보도록 하세.

1. ZombieFactory 아래에 ZombieFeeding 컨트랙트를 생성한다. 
이 컨트랙트는 ZombieFactory를 상속해야 한다.
 */
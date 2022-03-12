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
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}

/**
레슨 1에서 다뤘던 _createZombie 메소드를 업데이트하여 
이 함수를 호출하는 누구나 좀비 소유권을 부여하도록 해 보세.

1. 먼저, 새로운 좀비의 id가 반환된 후에 
zombieToOwner 매핑을 업데이트하여 
id에 대하여 msg.sender가 저장되도록 해보자.

2. 그 다음, 저장된 msg.sender을 고려하여 
ownerZombieCount를 증가시키자.

자바스크립트와 마찬가지로 솔리디티에서도 
uint를 ++로 증가시킬 수 있다.
 */
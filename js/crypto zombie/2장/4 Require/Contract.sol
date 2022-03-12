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

/**
우리의 좀비 게임에서 유저가 createRandomZombie 
함수를 반복적으로 호출해서 자신의 군대에 좀비를 무제한으로 
생성하는 것을 원하지 않네. 
그렇게 되면 게임이 재미없게 될 걸세.

1. require를 활용하여 유저들이 첫 좀비를 만들 때 
이 함수가 유저 당 한 번만 호출되도록 해 보세.

2. require 키워드를 createRandomZombie 앞부분에 입력한다. 
require 함수가 ownerZombieCount[msg.sender]이 
0과 같은지 확인하도록 하고, 
0이 아닌 경우 에러 메시지를 출력하도록 한다.

참고: 솔리디티에서 값을 비교할 때 어떤 항이 먼저 오느냐는 
중요하지 않네. 어떤 순서든 동일하지. 
하지만, 우리가 작성한 확인 기능은 매우 기본적이라서 
한 가지 답만을 참이라고 하네. 
그러니 ownerZombieCount[msg.sender]을 가장 먼저 작성 해주게.
 */
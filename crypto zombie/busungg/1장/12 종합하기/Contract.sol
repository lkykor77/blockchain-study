pragma solidity ^0.4.19;

contract ZombieFactory {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    //createZombie를 private 함수로 변경
    function _createZombie (string _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
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
1. createRandomZombie라는 public함수를 생성한다. 이 함수는 _name이라는 string형 인자를 하나 전달받는다. 
   (참고: 함수를 private로 선언한 것과 마찬가지로 함수를 public로 생성할 것)

2. 이 함수의 첫 줄에서는 _name을 전달받은 _generateRandomDna 함수를 호출하고, 
   이 함수의 반환값을 randDna라는 uint형 변수에 저장해야 한다.

3. 두번째 줄에서는 _createZombie 함수를 호출하고 이 함수에 _name와 randDna를 전달해야 한다.

4. 함수의 내용을 닫는 }를 포함해서 코드가 4줄이어야 한다.

 */
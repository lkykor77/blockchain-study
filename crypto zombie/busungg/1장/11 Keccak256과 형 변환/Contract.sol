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
}

/**
_generateRandomDna 함수의 내용을 채워 보세! 여기에 함수가 무엇을 해야 하는지 나와 있네:

코드 첫 줄에서는 _str을 이용한 keccak256 해시값을 받아서 의사 난수 16진수를 생성하고 이를 uint로 형 변환한 다음, rand라는 uint에 결과값을 저장해야 한다.

우리는 좀비의 DNA가 16자리 숫자이기만을 원하므로(dnaModulus를 기억하나?) 코드의 두번째 줄에서는 
위의 결과 값을 모듈로(%) dnaModulus로 연산한 값을 반환해야 한다. (형식: return 위의 결과 값 % dnaModulus).
 */
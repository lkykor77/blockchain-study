pragma solidity ^0.4.19;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {
    
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

    function feedAndMultiply(uint _zombieId, uint _targetDna) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        _createZombie("NoName", newDna);
    }
}

/**
getKitty 함수가 어떤 함수인지 알아 보았으니, 이를 이용하여 인터페이스를 만들어 볼 수 있을 걸세:

1. KittyInterface라는 인터페이스를 정의한다. 
인터페이스 정의가 contract 키워드를 이용하여 새로운 컨트랙트를 생성하는 것과 같다는 점을 기억할 것.

2. 인터페이스 내에 getKitty 함수를 선언한다 
(위의 함수에서 중괄호 안의 모든 내용은 제외하고 return 키워드 및 반환 값 
종류까지만 복사/붙여넣기 하고 그 다음에 세미콜론을 넣어야 한다).

*/
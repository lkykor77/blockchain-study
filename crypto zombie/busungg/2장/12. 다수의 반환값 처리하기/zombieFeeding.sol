pragma solidity ^0.4.19;

import "./zombiefactory.sol";

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

contract ZombieFeeding is ZombieFactory {
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    // `ckAddress`를 이용하여 여기에 kittyContract를 초기화한다.

    KittyInterface kittyContract = KittyInterface(ckAddress);

    function feedAndMultiply(uint _zombieId, uint _targetDna) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        _createZombie("NoName", newDna);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna);
    }
}

/**
이제 크립토키티 컨트랙트와 상호작용할 시간이네!

크립토키티 컨트랙트에서 고양이 유전자를 얻어내는 함수를 생성해 보세:

1. feedOnKitty라는 함수를 생성한다. 이 함수는 _zombieId와 _kittyId라는 uint 인자 값 2개를 전달받고, 
public 함수로 선언되어야 한다.

2. 이 함수는 kittyDna라는 uint를 먼저 선언해야 한다.

참고: KittyInterface 인터페이스에서 genes은 uint256형이지만, 
레슨 1에서 배웠던 내용을 되새겨 보면 uint는 uint256의 다른 표현으로, 서로 동일하지.

3. 그 다음, 이 함수는 _kittyId를 전달하여 kittyContract.getKitty 함수를 호출하고 
genes을 kittyDna에 저장해야 한다.getKitty가 다수의 변수를 반환한다는 사실을 기억할 것 
(정확히 말하자면 10개의 변수를 반환한다). 하지만 우리가 관심 있는 변수는 마지막 변수인 
genes이다. 쉼표 수를 유심히 세어 보기 바란다!

4. 마지막으로 이 함수는 feedAndMultiply를 호출하고 이 때 _zombieId와 kittyDna를 전달해야 한다.

*/
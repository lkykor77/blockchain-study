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

    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;

        if(keccak256(_species) == keccak256("kitty")){
            newDna = newDna - newDna % 100 + 99;
        }

        _createZombie("NoName", newDna);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}

/**
우리의 좀비 코드에 고양이 유전자에 대한 내용을 구현해 보세.

1. 먼저, feedAndMultiply 함수 정의를 변경하여 
_species라는 string을 세번째 인자 값으로 전달받도록 한다.

2.그 다음, 새로운 좀비 DNA를 계산한 후에 
if 문을 추가하여 _species와 "kitty" 스트링 각각의 keccak256 해시값을 비교하도록 한다.

3. if 문 내에서 DNA 마지막 2자리를 99로 대체하고자 한다. 
한가지 방법은 newDna = newDna - newDna % 100 + 99; 로직을 이용하는 것이다.

설명: newDna가 334455라고 하면 newDna % 100는 55이고, 
따라서 newDna - newDna % 100는 334400이다. 마지막으로 여기에 99를 더하면 334499를 얻게 된다.

4. 마지막으로, feedOnKitty 함수 내에서 이뤄지는 함수 호출을 변경해야 한다. 
feedAndMultiply가 호출될 때, "kitty"를 마지막 인자값으로 전달한다.
*/
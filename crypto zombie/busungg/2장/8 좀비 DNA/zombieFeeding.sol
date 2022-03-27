pragma solidity ^0.4.19;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {
    
    function feedAndMultiply(uint _zombieId, uint _targetDna) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        _createZombie("NoName", newDna);
    }
}

/**

먼저, _targetDna가 16자리보다 크지 않도록 해야 한다. 
이를 위해, _targetDna를 _targetDna % dnaModulus와 같도록 
해서 마지막 16자리 수만 취하도록 한다.

1. 그 다음, 함수가 newDna라는 uint를 선언하고 
myZombie의 DNA와 _targetDna의 평균 값을 부여해야 한다. 
(위의 예시 참고)

참고: myZombie.name와 myZombie.dna를 이용하여 
myZombie 구조체의 변수에 접근할 수 있지.

2. 새로운 DNA 값을 얻게 되면 _createZombie 함수를 호출한다. 
이 함수를 호출하는 데 필요한 인자 값을 zombiefactory.sol 
탭에서 확인할 수 있다. 
참고로, 이 함수는 좀비의 이름을 인자 값으로 필요로 한다. 
그러니 새로운 좀비의 이름을 현재로서는 "NoName"으로 하도록 하자. 
나중에 좀비 이름을 변경하는 함수를 작성할 수 있을 것이다.

*/
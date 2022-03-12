pragma solidity ^0.4.19;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {
    
    function feedAndMultiply(uint _zombieId, uint _targetDna) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
    }
}

/**
먹이를 먹고 번식하는 능력을 우리 좀비들에게 부여할 시간이네!

좀비가 어떤 다른 생명체를 잡아 먹을 때, 
좀비 DNA가 생명체의 DNA와 혼합되어 새로운 좀비가 생성될 것이네.

1. feedAndMultiply라는 함수를 생성한다. 
이 함수는 uint형인 _zombieId 및 _targetDna을 전달받는다. 
이 함수는 public으로 선언되어야 한다.

2. 다른 누군가가 우리 좀비에게 먹이를 주는 것을 원치 않는다.
 그러므로 주인만이 좀비에게 먹이를 줄 수 있도록 한다. 
 require 구문을 추가하여 msg.sender가 좀비 주인과 동일하도록 한다. 
 (이는 createRandomZombie 함수에서 쓰인 방법과 동일하다)

참고: 다시 말하지만, 우리가 작성한 확인 기능은 기초적이기 때문에 
컴파일러는 msg.sender가 먼저 나올 것을 기대하고, 
항의 순서를 바꾸면 잘못된 값이 입력되었다고 할 걸세. 
하지만 보통 코드를 작성할 때 항의 순서는
 자네가 원하는 대로 정하면 되네. 어떤 경우든 참이 되거든.

3. 먹이를 먹는 좀비 DNA를 얻을 필요가 있으므로, 
그 다음으로 myZombie라는 Zombie형 변수를 선언한다 
(이는 storage 포인터가 될 것이다). 
이 변수에 zombies 배열의 _zombieId 인덱스가 가진 값에 부여한다
 */
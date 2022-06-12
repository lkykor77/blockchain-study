pragma solidity >=0.5.0 <0.6.0;

import "./zombiehelper.sol";

// random number function to determine the outcome of battle 
// not totally secure from attack?
contract ZombieAttack is ZombieHelper {
  uint randNonce = 0;

   // Create attackVictoryProbability here
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
// cal the uint typecast of the keccak256 hash of encodepacked

 // 1. Add modifier here
 // Add the ownerOf modifier to attack to make sure the caller owns _zombieId.
 // 내가 이길 수 는 있는데, 먹어서 새로운 좀비 만드는 건 안된다 (feed and multiply는 안된다)


  function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
    // 이게 없어도 되나? require(_isReady(zombies[_zombieId])); 그래야 하루에 한번만 어택가능 

    // 2. Start function definition here
    //  storage pointer to both zombies so we can more easily interact with them:
    // 스토리지, zombiewincount, losecount, zombie 스트럭처에 넣는다 
    // 복사본 가져오면 안된다(기존 블록체인 상에 있는 좀비들의 원본 wincount/losscount 변경해야 한다)
    // 원본 내부에 있는 메모리를 변경해서 저장한다. storage 
    // storage 키워드 안쓰면, memory (정보 보여줄때만 사용), 3장, view 함수 사용해서 리스트만 보여준다, 복사본 가스 절약 
    // storage 는 비싸다. 블록체인에 영구적으로 기록. 컴퓨터에 텍스트파일 만든다. storage 쓸때만 가스 쓴다 
    // 기존것 myzombie 의 숫자 바꾼다 원본을 건드린다 , memory는 복사본 가져온다 (원본 변경 x)
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    // We're going to use a random number between 0 and 99 to determine the outcome of our battle. So declare a uint named rand, and set it equal to the result of the randMod function with 100 as an argument.
    uint rand = randMod(100); // randNonce, return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
    // kekkack256, 암호화 해시 펑션 (string) 넣으면 해시값으로 바꾸고 그걸 uint 로 바꾼다, 100으로 나눠서 남는 값 가져온다 
    
    // ch10. Now that we have a winCount and lossCount, we can update them depending on which zombie wins the fight.
    // In chapter 6 we calculated a random number from 0 to 100. Now let's use that number to determine who wins the fight, and update our stats accordingly.
    // 위에 victory probability 70%, 70 보다 아래면 내가 이긴것, 69이면. 
    // uint16 winCount = 좀비팩토리에서 const, 구조체에 추가해준다 
    if (rand<=attackVictoryProbability) {
        // if the condition is true, my zombie wins
        myZombie.winCount++;
        myZombie.level++;   //level up
        enemyZombie.lossCount++;
        // d. Run the feedAndMultiply function. Check zombiefeeding.sol to see the syntax for calling it. For the 3rd argument (_species), pass the string "zombie". (It doesn't actually do anything at the moment, but later we could add extra functionality for spawning zombie-based zombies if we wanted to).
        feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        // feedand mulitply 안에 require(_isready) 있으니까, 내가 이길때도 쿨타임 나온다 
        // 내가 어택해서 한번 쿨다운 한다. myzombie readytime 막힌다. trigger cooltime 호출 안된다. 그
        // 내가 졌으면, else에 쿨타임이 업데이트가 된다 
        // 어택을 한번 한 후에, 말

        //처음 어택에는 무조건 쿨타임 feedandmultiply 안에 쿨타임 있으니까
        // 두번째 어택때 이겼어, 하면 할수록 쿨타임 늘어난다. 
        // 어택을 해도 feed는 안된다. 하루에 한번만 어택 가능하다 의도면, is_ready를 어택안에 넣어야 한다. 
    
    // In our game, when zombies lose, they don't level down — they simply add a loss to their lossCount, and their cooldown is triggered so they have to wait a day before attacking again.
   
   // zombieFeeding, 내 쿨타임이 현재보다 더 전 시간일때, 그러면 사용할수 있는 것. _isReady
   // 내가 어택햇고, 성공하든 지든,쿨타임 돈다. is_ready 가 여기 안들어간다 

    //   function _triggerCooldown(Zombie storage _zombie) internal {
   // _zombie.readyTime = uint32(now + cooldownTime)
   //   }
    } else {
        myZombe.lossCount++;
        enemyZombie.winCount++;
        //This way the zombie can only attack once per day. (Remember, _triggerCooldown is already run inside feedAndMultiply. So the zombie's cooldown will be triggered whether he wins or loses.)
    }
    // 내가 attack 했으면, 내 좀비는 무조건 cooldown, else 밖에 있어야 한다 .
    _triggerCooldown(myZombie);
  }

}


/*
// // Generate a random number between 1 and 100:
uint randNonce = 0;
uint random = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 100;
randNonce++;
uint random2 = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 100;

타임스탬프 (now, msg.sender, randNonce) 논스값은 계속 incrementing 올라간다. 한번만 쓰이게 
이 인풋들을 다 pack 한다음. keccak 을 이용해서 랜덤 해시값 생성, 이걸 %100 하면, 끝의 두자리 숫자만 나온다. 0-99

What this would do is take the timestamp of now, the msg.sender, and an incrementing nonce 
(a number that is only ever used once, so we don't run the same hash function with the same input parameters twice).
It would then "pack" the inputs and use keccak to convert them to a random hash. Next, it would convert that hash to a uint, and then use % 100 to take only the last 2 digits. This will give us a totally random number between 0 and 99.
*/
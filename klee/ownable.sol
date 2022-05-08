pragma solidity >=0.5.0 <0.6.0;

/**
* @title Ownable
* @dev The Ownable contract has an owner address, and provides basic authorization control
* functions, this simplifies the implementation of "user permissions".
우리의 컨트랙트를 우리가 수정하겠다 
문제가 생기면 어쩔 수 없다. 주소 바꾼다든지. 주소 바꾸는 함수들 퍼블릭으로 만들면, 컨트랙트 호출해서 다른 의도하지 않은 사용자들가지도 함수 사용
보안에 취약 
컨트랙트 실 소유자만 그 함수를 사용할 수 있게 하면 ownable 
라이브러리 open zeppelin 

*/
contract Ownable {
  address private _owner;   // 오너 주소가 private으로 기록 남는다. private이니까 누구도 접근 불가능. 

// 이벤트는: 로그 기록 남기려고. 예상 
  event OwnershipTransferred(   
    address indexed previousOwner,
    address indexed newOwner
  );

  /**
  * @dev The Ownable constructor sets the original `owner` of the contract to the sender
  * account.
  컨스트럭터: 생성자 . 컨트랙트와 동일한 이름 가진, 생략할 수 있는 특별 함수. 컨트랙트가 생성될 때 딱 한 번만 실행됨.
  계약 실행되면 이게 한번만 호출 된다. 
  배포할때 호출. 내 주소로 호출. 내가 msg_sender = _owner 
  
  address(0) is special case, indicate new contract is being deployed. 새로운 컨트랙트 배포되는 것을 의미. 
  
  이벤트: ownershiptransferred. 실제 내용은 라이브러리 안에 있다 
  이벤트의 바디를 만드는 것은 아직 안배웠다. 
  */
  constructor() internal {
    _owner = msg.sender;
    emit OwnershipTransferred(address(0), _owner);   // 굳이 이 이벤트 필요 없을 수도 있다 
    
  }

  /**
  * @return the address of the owner. 전체 퍼블릭이 오너 어드레스 다 볼 수 있다 
  */
  function owner() public view returns(address) {
    return _owner;
  }

  /**
  * @dev Throws if called by any account other than the owner.
  // require: 함수 제어자. 함수처럼 보이지만 modifier 키워드 사용. 함수 호출하듯이 직접 호출할 수 없다 . 
  // 하지만 함수 정의부 끝에 해당 함수의 작동방식을 바꾸도록 제어자 이름 붙일 수 있다. 
  // 함수의 작동 방식을 바꾼다. 함수 제어자 modifier 의 코드가 위로 올라간다. 
modifier onlyOwner() {
  require(msg.sender == owner);
  _;  -- 이게 다시 돌아가라 뜻. 순서 저장, likeaBoss 로 다시 돌아간다. 
}

contract Mycontract is Ownable {
  event LaughManically(string laughter);

  function likeaBoss() external onlyOwner {
    LaughManically("Muahhahah");
  }
}

  */
  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  /**
  * @return true if `msg.sender` is the owner of the contract.  bool = true 나온다 
  */
  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }

  /**  특별 케이스. 계약 완전 버린다. 스테이블 버전. 작성자가 더이상 수정 못한다. 변경 필요 없다.
  ownable inherit 는 zombiefactory/feeding 에서 몇가지 주소만 inherit. 
  다른 기능들 사용 가능. 작성자가 사라진다 
  * @dev Allows the current owner to relinquish control of the contract.
  * @notice Renouncing to ownership will leave the contract without an owner.
  * It will not be possible to call the functions with the `onlyOwner`
  * modifier anymore.
  */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);   // address(0) 초기화 한다. 내 _owner 주소 초기화
  }



  /**
  * @dev Allows the current owner to transfer control of the contract to a newOwner.
  * @param newOwner The address to transfer ownership to.
// 내가 오너인지 확인하고, require, 그다음 transfer ownership 한다 
부성이가 나한테 주고 싶어. 
부성이 : address a
나: address b
여기서 address b를 나한테 줘야 하는데, 잘못되서 기초상태로 줬다. 
newOwner = address(0);
이걸 방지할려고. 
기초상태로 address(0) 으로 되면 renounceOwnership 이 되니까.

  */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
  * @dev Transfers control of the contract to a newOwner.
  * @param newOwner The address to transfer ownership to.
  internal: 내부 호출. 상속하는 컨트랙트에서도 접근 가능. 
  private 동일하게 외부 컨트랙트 접근 불가. 
  내부 호출 / 상속 가능 
  ownable 상속이 zombiefactory, zombiefeeding 되니까, 이것도 쓸수 있다 
  */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));   // address(0) 기초화 뜻인데, 이걸 방지할려고. 
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;   //여기서 owner 를 newowner 주소로 바꿔준다. 
  }

}


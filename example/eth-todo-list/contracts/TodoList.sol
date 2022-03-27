pragma solidity >=0.4.22 <0.9.0;

contract TodoList {
    uint public taskCount = 0;

    struct Task {
        uint id;
        string content;
        bool completed;
    }

    constructor() public {
        createTask("Check out dappuniversity.com");
        createTask("1");
        createTask("2");
        createTask("3");
        createTask("4");
        createTask("5");
    }

    mapping(uint => Task) public tasks;

    function createTask(string memory _content) public {
        taskCount++;
        tasks[taskCount] = Task(taskCount, _content, false);
    }
}

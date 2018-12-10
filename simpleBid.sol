pragma solidity ^0.4.24;

contract simpleAction {

    struct bidder {
        address bidderAddress;
        uint tokenBought;
        mapping (bytes32 => uint) myBid; // �� ������
    }


    mapping (address => bidder) public bidders; // �����ڵ��� �ּ�
    mapping (bytes32 => uint) public highest; // �ְ� ������

    bytes32[] public productNames; // ��ǰ �迭

    uint public tokenPrice; // ��ū ����

    constructor(uint _tokenPrice) public
    {
        tokenPrice = _tokenPrice;

        productNames.push("iPhone 7");
        productNames.push("iPhone 8");
        productNames.push("iPhone X");
        productNames.push("Galaxy S9");
        productNames.push("Galaxy Note 9");
        productNames.push("LG G7");
    }

    function buy() payable public returns (int)
    {
        uint tokensToBuy = msg.value / tokenPrice;
        bidders[msg.sender].bidderAddress = msg.sender;
        bidders[msg.sender].tokenBought += tokensToBuy;
    }

    function getHighestBid() view public returns (uint, uint, uint, uint, uint, uint)
    {
        return (highest["iPhone 7"],
        highest["iPhone 8"],
        highest["iPhone X"],
        highest["Galaxy S9"],
        highest["Galaxy Note 9"],
        highest["LG G7"]);
    }

    function bid(bytes32 productName, uint tokensToBid)
    {
        uint index = getProductIndex(productName);
        require(index != uint(-1));

        require(tokensToBid > bidders[msg.sender].myBid[productName]);
        require(tokensToBid <= (bidders[msg.sender].myBid[productName] + bidders[msg.sender].tokenBought));


        bidders[msg.sender].tokenBought -= (tokensToBid - bidders[msg.sender].myBid[productName]);
        bidders[msg.sender].myBid[productName] = tokensToBid;

        if(tokensToBid > highest[productName]){
            highest[productName] = tokensToBid;
        }
    }

    function getProductIndex(bytes32 productName) view public returns (uint)
    {
        for(uint i=0; i< productNames.length; i++)
        {
            if(productNames[i] == productName)
            {
                return i;
            }
        }
        return uint(-1);
    }

    function getProductsInfo() view public returns (bytes32[])
    {
        return productNames;
    }

    function getTokenPrice() view public returns(uint)
    {
        return tokenPrice;
    }

    function getTokenBought() view public returns(uint)
    {
        return bidders[msg.sender].tokenBought;
    }
}
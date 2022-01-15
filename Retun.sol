// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.6;
// import "@nomiclabs/builder/console.sol";
contract ReturnSolution {
    ///////////////////////////
    // All variable declarations
    ///////////////////////////
    string private transactionCode;
    uint private negotiatedValue;
    address private seller;
    address private buyer;
    address private logistic;
    address private mediator;
    string private buyerAddress;
    string private sellerAddress;
    string private logisticSecretCode;
    string private transactionSecretCode;
    enum State { 
            Created, 
            ReturnRequested, 
            ReturnRequestAccepted, 
            ReturnRequestRejected, 
            MediatorInvolved,
            ReturnPackageReceived, 
            ReturnPackageRejected, 
            MediatorReceivedProduct,
            MediatorAnnounceResult,
            Shipped,
            AcceptReturnedProduct,
            Inactive }
    bool hasProductArrivedToMediator = false;
    State private state;

    event LogErrorString(string message);
    ///////////////////////////
    // All modifiers
    ///////////////////////////
    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can call this method");
        _;
    }
    
    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this method");
        _;
    }
    
    modifier onlyLogistic() {
        require(msg.sender == logistic, "Only logistic team can call this method");
        _;
    }
    
    modifier onlyMediator() {
        require(msg.sender == mediator, "Only mediator can call this method");
        _;
    }

   modifier inState(State state_) {
       require(state == state_, "Out of state");
        _;
    }

     modifier condition(bool condition_, string memory message) {
        require(condition_, message);
        _;
    }

    ///////////////////////////
    // All methods
    ///////////////////////////
    // Creating the contract by passing the negotiated value and secret code
    constructor(uint value,  string memory secretCode, address _buyer, address _seller, address _logistic, address _mediator) {
        negotiatedValue = value * 1 ether;
        transactionSecretCode = secretCode;
        state = State.Created;
        buyer = _buyer;
        seller = _seller;
        logistic = _logistic;
        mediator = _mediator;
    }

    // Responsible for verifying that the passed codes matches
    function IsValidSecretKey(string memory codeB, string memory codeA)pure public returns (bool){
        if(keccak256(abi.encodePacked(codeA)) != keccak256(abi.encodePacked(codeB))){
            return false;
        }
        return true;
    }
    
    // @todo function to abort()
    function abort() private{
        state = State.Created;
    }

    // 1. Responsible for Inacting the return ReturnRequest
    function InitiateReturnRequest()
    public 
    onlyBuyer
    inState(State.Created)
    {
        emit LogErrorString("STATE_CHANGED");
        state = State.ReturnRequested;
    }

    // 2. Seller aceepts return
    function SellerAcceptReurn() 
    public 
    onlySeller
    inState(State.ReturnRequested)
    {
        emit LogErrorString("REQUEST_ACCEPTED");
        state = State.ReturnRequestAccepted;
    }

    // 3. Seller reject return
    function SellerRejectReturn()
    public 
    onlySeller
    inState(State.ReturnRequested)
    {
        emit LogErrorString("REQUEST_REJECTED");
        state = State.ReturnRequestRejected;
    }

    // 3A. Buyer Involves mediator
    function BuyerInvolveMediator()
    public 
    onlyBuyer
    inState(State.ReturnRequestRejected)
    {
        emit LogErrorString("BUYER_INVOLVE_MEDIATOR");
        state = State.MediatorInvolved;
    }

    // 3B. @todo Mediator decide in favour of Buyer
    function MediatorAnnounceBuyerWin()
    public 
    onlyMediator
    inState(State.MediatorReceivedProduct)
    {
        emit LogErrorString("BUYER_INVOLVE_MEDIATOR");
        state = State.MediatorAnnounceResult;
        _RefundBuyer();
    }

    // 3C. @todo Mediator decide in favour of Seller
    function MediatorAnnounceSellerWin()
    public 
    onlyMediator
    inState(State.MediatorReceivedProduct)
    {
        emit LogErrorString("BUYER_INVOLVE_MEDIATOR");
        state = State.MediatorAnnounceResult;
        _RefundSeller();
    }

    // 4. Signifies that the buyer have initiated the shipping
    function BuyerInitiateShipping()
    public 
    onlyLogistic
    inState(State.ReturnRequestAccepted)
    {
        emit LogErrorString("PRODUCT_SHIPPED");
        state = State.Shipped;
    }

    // 5. Seller confirms that he received the product and he accepts the return
    function SellerAcceptsReturnedProduct()
    public 
    onlySeller
    inState(State.Shipped)
    {
        emit LogErrorString("RETURNED_PRODUCT_ACCEPTED");
        state = State.AcceptReturnedProduct;
        // balance transfer to buyer
        _RefundBuyer();
    }

    // 6.  Seller reject returns and involve mediator
    function SellerRejectReturnedProduct()
    public 
    onlySeller
    inState(State.Shipped)
    {
        emit LogErrorString("SELLER_INVOLVE_MEDIATOR");
        state = State.MediatorInvolved;
    }

    // 7. Mediator confirms that they got the product
    function MediatorConfirmProductDelivery() 
    public 
    onlyMediator
    inState(State.MediatorInvolved)
    {
        emit LogErrorString("MEDIATOR_RECEIVED_PRODUCT");
        state = State.MediatorReceivedProduct;
    }

    function _PreBuyerDeposit() public 
    payable 
    onlyBuyer 
    condition(msg.value == negotiatedValue, "Invalid token deposited")
    inState(State.Created) {
        emit LogErrorString("DEPOSIT_CONFIRMED");
    }

    function _RefundBuyer() private{
        payable(buyer).transfer(address(this).balance);
        emit LogErrorString("REFUND_BUYER_COMPLETE");
    }
    
    function _RefundSeller() private{
        payable(seller).transfer(address(this).balance);
        emit LogErrorString("REFUND_SELLER_COMPLETE");
    }
    ///////////////////////////
    // Methods to test
    ///////////////////////////
    function CurrentState() view public returns (State) {
        return state;
    }
}

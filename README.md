# Solidity Contract for the return process in p2p e-commerce
The Return.sol explains various methods called by different stakeholders of a p2p e-commerce return process, like - 
1. Buyer, 2. Seller, 3. Logistic Team, 4. Mediator

Each of the stakeholders would call differnt methods, based on the state at which they are in.
e.g. BuyerInvolveMediator() can not be called before InitiateReturnRequest() 

A typical workflow for return would consider that buyer have deposited some(mentioned in the contract) token in the escrow, for which we call the method 
_PreBuyerDeposit() and also, buyer have the item. 
Next, following methods are called in the following order - 

<img src="Screenshot 2022-01-15 at 11.14.08 PM.png" width="1280"/>

# How to run
Visit https://remix.ethereum.org/ and run Retun.sol

const crypto = require('crypto');
class Block {
   constructor(index, data, prevHash) {
       this.index = index;
       this.timestamp = Math.floor(Date.now() / 1000);
       this.data = data;
       this.prevHash = prevHash;
       this.hash=this.getHash();
   }

   /**
    * we are making the hash with data, prevHash, index and timeStamp
    * so if any of these changes, the entire chain would be invalidated
    */
   getHash() {
       var encript=JSON.stringify(this.data) + this.prevHash + this.index + this.timestamp;
       var hash=crypto.createHmac('sha256', "secret")
       .update(encript)
       .digest('hex');
       // return sha(JSON.stringify(this.data) + this.prevHash + this.index + this.timestamp);
       return hash;
   }
}


class BlockChain {
   constructor() {
       this.chain = [];
   }

   addBlock(data) {
       let index = this.chain.length;
       let prevHash = this.chain.length !== 0 ? this.chain[this.chain.length - 1].hash : 0;
       let block = new Block(index, data, prevHash);
       this.chain.push(block);
   }

   updateInChain(data, index){
    for(var i = 0; i < this.chain.length; i++){
        if(i === index){
            this.chain[i].data = data;
        }
    }
    return true;
   }

    /**
     * basically parsing through the data and check if the data and hash is matching
     * and also the prevHash of this object should be same as that of the previous object's hash
     */
   chainIsValid(){
           for(var i=0;i<this.chain.length;i++){
               if(this.chain[i].hash !== this.chain[i].getHash())
                   return false;
               if(i > 0 && this.chain[i].prevHash !== this.chain[i-1].hash)
                   return false;
           }
           return true;
       }
}


const BChain = new BlockChain();
BChain.addBlock({sender: "Bruce wayne", reciver: "Tony stark", amount: 100});
BChain.addBlock({sender: "Harrison wells", reciver: "Han solo", amount: 50});
BChain.addBlock({sender: "Tony stark", reciver: "Ned stark", amount: 75});
console.dir(BChain,{depth:null})

console.log("******** Validity of this blockchain: ", BChain.chainIsValid());

/**
 * if we add an extra node
 */
console.log("######## Adding a new node");
BChain.addBlock({sender: "Loki", reciver: "Thor", amount: 15});
console.log("******** Validity of this blockchain: ", BChain.chainIsValid());

/**
 * demonstration of blockchain, in case the data is mutated
 */
console.log("######## After updating a data");
BChain.updateInChain({sender: "Bruce wayne", reciver: "Tony stark", amount: 100}, 1);
console.log("******** Validity of this blockchain: ", BChain.chainIsValid());

/**
 * adding a node, after the data has been updated
 */
console.log("######## Adding a new node after modification");
BChain.addBlock({sender: "Loki", reciver: "Thor", amount: 15});
console.log("******** Validity of this blockchain: ", BChain.chainIsValid());

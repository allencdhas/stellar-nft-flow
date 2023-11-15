import "NonFungibleToken"

import NonFungibleToken from "./NonFungibleToken.cdc"

pub contract Stellar: NonFungibleToken {

    //pub var ownedNFTs: @{UInt64: NFT}


    pub var totalSupply: UInt64

    pub resource NFT {
        pub let id: UInt64

        init() {
            self.id = self.uuid
            Stellar.totalSupply = Stellar.totalSupply + 1
        }
    }

    pub resource NFTMinter {
        pub fun createNFT(): @NFT {
            return <-create NFT()
        }

        init() {}
    }

    init() {
        self.totalSupply = 0
        self.account.save(<- create NFTMinter(), to: /storage/NFTMinter)
        
    }

    //Collection Interface!! -- Collection block ->
    pub resource interface CollectionPublic {
        pub fun deposit(token: @NFT)
        pub fun getIDs(): [UInt64]
    }

    pub resource Collection {
        pub var ownedNFTs: @{UInt64: NFT}

        pub fun deposit(token: @NFT) {
            let tokenID = token.id
            self.ownedNFTs[token.id] <-! token
        }

        pub fun withdraw(withdrawID: UInt64): @NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("Token not in collection")
            return <- token
        }

        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        init() {
            self.ownedNFTs <- {}
        }

        destroy () {
            destroy self.ownedNFTs
        }
    }

    pub fun createEmptyCollection(): @Collection {
        return <-create Collection()
    }

}

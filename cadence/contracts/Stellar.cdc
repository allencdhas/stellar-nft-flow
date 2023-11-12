pub contract Stellar {


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

}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 is IERC165 {
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function approve(address to, uint256 tokenId) external;

    function setApprovalForAll(address operator, bool approved) external;

    function getApproved(uint256 tokenId)
        external
        view
        returns (address operator);

    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);
}

interface ISmartHomes is IERC721 {
    function burn(uint256 tokenId) external;

    function mint(
        address to,
        uint256 tokenId,
        string memory tokenURI
    ) external;

    function getNFTCounter() external view returns (uint256);
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract SmartHomesShares {
    ISmartHomes nftContract;
    address USDT;
    address reciever = 0xD38eaedED0589ED4aBaEbEC1d9500205f363102b;
    string tokenURITier1 =
        "https://turquoise-magic-grouse-543.mypinata.cloud/ipfs/bafkreic3bzmhxuazmdoompbi6jqj4rdsv6kb67dyjdebvx23qk2cbqdaku";
    string tokenURITier2 =
        "https://turquoise-magic-grouse-543.mypinata.cloud/ipfs/bafkreihm7wgo4i4erd5empmyrpshugp6amhc66wqskfn34ene2dli7kjdq";
    string tokenURITier3 =
        "https://turquoise-magic-grouse-543.mypinata.cloud/ipfs/bafkreia7wzkhpnsk5d44jlyebdyb4itxygyrne5lncrzz5dcizdb33kuta";
    string tokenURITier4 =
        "https://turquoise-magic-grouse-543.mypinata.cloud/ipfs/bafkreibd4ywepl4hzlk33wfuiv2uyeg7zcwopkzy4o6i2shzyhlhbm4vjq";
    string tokenURITier5 =
        "https://turquoise-magic-grouse-543.mypinata.cloud/ipfs/bafkreib3hwhc7ymar46xcflng4oxmsrcq4cw6h6ou7roofr5rakr56dpoa";
    string tokenURITier6 =
        "https://turquoise-magic-grouse-543.mypinata.cloud/ipfs/bafkreih2rzbimywxjmorfndpo46wa6cboamsrzbexgmh4whsnw65kvxba4";
    string tokenURITier7 =
        "https://turquoise-magic-grouse-543.mypinata.cloud/ipfs/bafkreian4f47oa3jambr3pt4tvxsizldhp24i3lfolyc7agwqqnbtj3jxa";
    string tokenURITier8 =
        "https://turquoise-magic-grouse-543.mypinata.cloud/ipfs/bafkreihdjtzvfu64f47x3dmtemx3gygmmqsairgsrpudcxzvcuhw37mhcu";
    struct Tier {
        uint256 shares;
        uint256 donation;
        uint256 startLimit;
        uint256 endLimit;
    }
    mapping(uint8 => Tier) public tiers;
    mapping(address => mapping(uint256 => uint256)) userShares;
    mapping(address => uint256) userTotalShares;
    mapping(uint256 => uint256) tierMintedNft;

    constructor() {
        nftContract = ISmartHomes(0x4130E16Eed2c49a0183C180f5d9A4cb52A40b820);
        USDT = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
        tierMintedNft[1] = 1;
        tierMintedNft[2] = 20001;
        tierMintedNft[3] = 30001;
        tierMintedNft[4] = 35001;
        tierMintedNft[5] = 37001;
        tierMintedNft[6] = 38001;
        tierMintedNft[7] = 38801;
        tierMintedNft[8] = 39401;
        tiers[1] = Tier(25, 25, 1, 20000);
        tiers[2] = Tier(53, 50, 20001, 30000);
        tiers[3] = Tier(110, 100, 30001, 35000);
        tiers[4] = Tier(230, 200, 35001, 37000);
        tiers[5] = Tier(355, 300, 37001, 38000);
        tiers[6] = Tier(490, 400, 38001, 38800);
        tiers[7] = Tier(2100, 1000, 38801, 39400);
        tiers[8] = Tier(3800, 2200, 39401, 39900);
    }

    function transferUSDT(uint8 _tier) private {
        uint8 _decimals = IERC20Metadata(USDT).decimals();
        Tier memory t = tiers[_tier];
        uint256 value = t.donation;
        value = value * 10**_decimals;
        require(
            IERC20(USDT).balanceOf(msg.sender) >= value,
            "you should have insufficient USDT to donate in Tier "
        );
        IERC20(USDT).transferFrom(msg.sender, address(this), value);
        IERC20(USDT).transfer(reciever, value);
    }

    function mintNFT(uint8 _tier, string memory _tokenURI) private {
        Tier memory t = tiers[_tier];
        uint256 mintedNFT = tierMintedNft[_tier];
        require(
            mintedNFT >= t.startLimit && mintedNFT <= t.endLimit,
            "Tier Amount Completed"
        );
        uint256 tokenId = tierMintedNft[_tier];
        nftContract.mint(msg.sender, tokenId, _tokenURI);
        tierMintedNft[_tier] = tokenId + 1;
    }

    function donate(uint256 _donationAmount) external {
        require(nftContract.getNFTCounter() <= 39900, "All tiers are filled");
        require(
            _donationAmount == 25 ||
                _donationAmount == 50 ||
                _donationAmount == 100 ||
                _donationAmount == 200 ||
                _donationAmount == 300 ||
                _donationAmount == 500 ||
                _donationAmount == 1000 ||
                _donationAmount == 2200,
            "wrong donation amount it is 25 or 50 or 100 or 200 or 300 or 500 or 1000 or 2200"
        );
        if (_donationAmount == 25) {
            transferUSDT(1);
            mintNFT(1, tokenURITier1);
        }
        if (_donationAmount == 50) {
            transferUSDT(2);
            mintNFT(2, tokenURITier2);
        }
        if (_donationAmount == 100) {
            transferUSDT(3);
            mintNFT(3, tokenURITier3);
        }
        if (_donationAmount == 200) {
            transferUSDT(14);
            mintNFT(4, tokenURITier4);
        }
        if (_donationAmount == 300) {
            transferUSDT(5);
            mintNFT(5, tokenURITier5);
        }
        if (_donationAmount == 500) {
            transferUSDT(6);
            mintNFT(6, tokenURITier6);
        }
        if (_donationAmount == 1000) {
            transferUSDT(7);
            mintNFT(7, tokenURITier7);
        }
        if (_donationAmount == 2200) {
            transferUSDT(8);
            mintNFT(8, tokenURITier8);
        }
    }

    function _share(uint8 _tier) private {
        require(_tier <= 8, "invalid tier");
        require(_tier != 0, "tier should be greater than 0");
        Tier memory t = tiers[_tier];
        uint256 value = t.shares;
        uint256 shareValue = userShares[msg.sender][_tier];
        userShares[msg.sender][_tier] = value + shareValue;
        uint256 totalShare = userTotalShares[msg.sender];
        userTotalShares[msg.sender] = value + totalShare;
    }

    function burnNFT(uint256 tokenId) private {
        ISmartHomes _nftContract = ISmartHomes(address(nftContract));
        require(
            _nftContract.ownerOf(tokenId) == msg.sender,
            "You are not the owner of this token"
        );
        nftContract.burn(tokenId);
    }

    function Shares(uint256 tokenId) external {
        if (tokenId > 0 && tokenId <= 20000) {
            _share(1);
            burnNFT(tokenId);
        }
        if (tokenId > 20000 && tokenId <= 30000) {
            _share(2);
            burnNFT(tokenId);
        }
        if (tokenId > 30000 && tokenId <= 35000) {
            _share(3);
            burnNFT(tokenId);
        }
        if (tokenId > 35000 && tokenId <= 37000) {
            _share(4);
            burnNFT(tokenId);
        }
        if (tokenId > 37000 && tokenId <= 38000) {
            _share(5);
            burnNFT(tokenId);
        }
        if (tokenId > 38000 && tokenId <= 38800) {
            _share(6);
            burnNFT(tokenId);
        }
        if (tokenId > 38800 && tokenId <= 39400) {
            _share(7);
            burnNFT(tokenId);
        }
        if (tokenId > 39400 && tokenId <= 39900) {
            _share(8);
            burnNFT(tokenId);
        }
    }

    function getUserShares(address user) external view returns (uint256) {
        return userTotalShares[user];
    }

    function getUserSharesByTier(address user, uint8 tier)
        external
        view
        returns (uint256)
    {
        return userShares[user][tier];
    }

    function donationCurrency() public view returns (address) {
        return USDT;
    }

    function nftAddress() public view returns (address) {
        return address(nftContract);
    }

    modifier onlyReciever() {
        require(reciever == msg.sender, "only Reciever can call");
        _;
    }

    function updateTierValue(
        uint8 _tier,
        uint256 _shares,
        uint256 _donation,
        uint256 _startLimit,
        uint256 _endLimit
    ) public onlyReciever {
        Tier storage t = tiers[_tier];
        t.donation = _donation;
        t.endLimit = _endLimit;
        t.shares = _shares;
        t.startLimit = _startLimit;
    }

    function getTierInfo(uint8 _tier)
        public
        view
        returns (
            uint256 _shares,
            uint256 _donation,
            uint256 _startLimit,
            uint256 _endLimit
        )
    {
        Tier memory t = tiers[_tier];
        return (t.shares, t.donation, t.startLimit, t.endLimit);
    }
}

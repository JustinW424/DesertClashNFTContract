// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./IPool.sol";
import "./GOLD.sol";
import "./ICamelit.sol";

contract Camelit is ICamelit, ERC721Enumerable, Ownable, Pausable {
    // mint price
    uint256 public constant MINT_PRICE = 0.03 ether;
    // max number of tokens that can be minted - 15000 in production
    uint256 public immutable MAX_TOKENS;
    // number of tokens that can be claimed for free - 50% of MAX_TOKENS
    uint256 public PAID_TOKENS;
    // number of tokens have been minted so far
    uint16 public minted;

    // the text which saved the token is camel or Bandit
    string CAMEL_BANDIT;

    // Token's type
    mapping(address => uint256[]) public ownedTokens;

    // reference to the Pool for choosing random Bandit
    IPool public pool;
    // reference to $GOLD for burning on mint
    GOLD public gold;

    /**
     * instantiates contract and rarity tables
     */
    constructor(
        // address _gold,
        uint256 _maxTokens,
        string memory _camelbandit
    ) ERC721("Desert Clash Game", "DesertGAME") {
        // gold = GOLD(_gold);
        MAX_TOKENS = _maxTokens;
        PAID_TOKENS = 5000;
        CAMEL_BANDIT = _camelbandit;
    }

    /** EXTERNAL */

    /**
     * mint a token - 90% Camel , 10% Bandit
     * The first 50% are free to claim, the remaining cost $GOLD
     */
    function mint(uint256 amount, bool stake) external payable whenNotPaused {
        require(tx.origin == _msgSender(), "Only EOA");
        require(
            ownedTokens[_msgSender()].length <= 35,
            "Overflow the amount of the maximum ownable token"
        );
        require(minted + amount <= MAX_TOKENS, "All tokens minted");
        require(amount > 0 && amount <= 5, "Invalid mint amount");
        if (minted < PAID_TOKENS) {
            require(
                minted + amount <= PAID_TOKENS,
                "All tokens on-sale already sold"
            );
            require(amount * MINT_PRICE == msg.value, "Invalid payment amount");
        } else {
            require(msg.value == 0);
        }

        // for test.
        // uint256 totalGold = 0;
        // uint16[] memory tokenIds = stake
        //     ? new uint16[](amount)
        //     : new uint16[](0);
        // uint256 seed;
        // for (uint256 i = 0; i < amount; i++) {
        //     minted++;
        //     seed = random(minted);
        //     generate(minted, seed);
        //     address recipient = selectRecipient(seed);
        //     if (!stake || recipient != _msgSender()) {
        //         _safeMint(recipient, minted);
        //     } else {
        //         _safeMint(address(pool), minted);
        //         tokenIds[i] = minted;
        //     }
        //     totalGold += mintCost(minted);
        // }

        // if (totalGold > 0) gold.burn(_msgSender(), totalGold);
        // if (stake) pool.addManyToPool(_msgSender(), tokenIds);
    }

    /** 
   * the first 50% are paid in ETH
   * the mint price will increase 15 $GOLD every 200 mints.

   * @param tokenId the ID to check the cost of to mint
   * @return the cost of the given token ID
   */
    function mintCost(uint256 tokenId) public view returns (uint256) {
        if (tokenId <= PAID_TOKENS) return 0;
        return 15 * ((tokenId - PAID_TOKENS - 1) / 200 + 1);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        // Hardcode the Pool's approval so that users don't have to waste gas approving
        if (_msgSender() != address(pool))
            require(
                _isApprovedOrOwner(_msgSender(), tokenId),
                "ERC721: transfer caller is not owner nor approved"
            );
        _transfer(from, to, tokenId);
    }

    // function getPaidTokens() external view override returns (uint256) {
    //     return PAID_TOKENS;
    // }

    /** ADMIN */

    /**
     * called after deployment so that the contract can get random wolf thieves
     * @param _pool the address of the Barn
     */
    function setBarn(address _pool) external onlyOwner {
        pool = IPool(_pool);
    }

    /**
     * allows owner to withdraw funds from minting
     */
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    /**
     * updates the number of tokens for sale
     */
    function setPaidTokens(uint256 _paidTokens) external onlyOwner {
        PAID_TOKENS = _paidTokens;
    }

    /**
     * enables owner to pause / unpause minting
     */
    function setPaused(bool _paused) external onlyOwner {
        if (_paused) _pause();
        else _unpause();
    }

    /**
     * get the string from begin to end of the text
     */
    function getSlice(
        uint256 begin,
        uint256 end,
        string memory text
    ) public pure returns (string memory) {
        bytes memory a = new bytes(end - begin + 1);
        for (uint256 i = 0; i <= (end - begin); i++)
            a[i] = bytes(text)[i + begin - 1];

        return string(a);
    }

    /**
     * generate the random number between 1 ~ 12500
     */
    function rand(uint256 range) public view returns (uint256) {
        uint256 seed = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, msg.sender)
            )
        ) % range;
        return seed;
    }

    function getTokenIdAndMarkAsUsed(
        string memory camelbandit,
        uint256 randomindex
    ) public pure returns (uint256, uint8) {
        bytes memory a = new bytes(1);
        while (uint8(a[0]) == 2) {
            a[0] = bytes(camelbandit)[randomindex];
        }
        return (randomindex, uint8(a));
    }
}

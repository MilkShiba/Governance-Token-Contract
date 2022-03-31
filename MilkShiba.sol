
// SPDX-License-Identifier: MIT


/*
    
    MilkShiba - the one true Shib on Milkomeda

    www.MilkShiba.com

    t.me/MilkShiba

*/

pragma solidity ^0.8.12;

library SafeMathInt {
    int256 private constant MIN_INT256 = int256(1) << 255;
    int256 private constant MAX_INT256 = ~(int256(1) << 255);

    function mul(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a * b;

        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
        require((b == 0) || (c / b == a));
        return c;
    }

    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != -1 || a != MIN_INT256);

        return a / b;
    }

    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));
        return c;
    }

    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }

    function abs(int256 a) internal pure returns (int256) {
        require(a != MIN_INT256);
        return a < 0 ? -a : a;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

     

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IDEXPair {
		function factory() external view returns (address);
		function token0() external view returns (address);
		function token1() external view returns (address);
		function sync() external;
}

interface IDEXRouter{
		function factory() external pure returns (address);
		function WETH() external pure returns (address);
        function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
		function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
		function addLiquidityETH(
				address token,
				uint amountTokenDesired,
				uint amountTokenMin,
				uint amountETHMin,
				address to,
				uint deadline
		) external payable returns (uint amountToken, uint amountETH, uint liquidity);
		function swapExactTokensForTokens(
				uint amountIn,
				uint amountOutMin,
				address[] calldata path,
				address to,
				uint deadline
		) external returns (uint[] memory amounts);
		function swapTokensForExactTokens(
				uint amountOut,
				uint amountInMax,
				address[] calldata path,
				address to,
				uint deadline
		) external returns (uint[] memory amounts);  
		function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
				external
				returns (uint[] memory amounts); 
		function swapExactTokensForTokensSupportingFeeOnTransferTokens(
			uint amountIn,
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external;
		function swapExactTokensForETHSupportingFeeOnTransferTokens(
			uint amountIn,
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external;
}

interface IDEXFactory {
		function getPair(address tokenA, address tokenB) external view returns (address pair);
		function createPair(address tokenA, address tokenB) external returns (address pair);
}

contract Ownable {
    address private _owner;

    event OwnershipRenounced(address indexed previousOwner);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = msg.sender;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipRenounced(_owner);
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

abstract contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

contract MilkShiba is ERC20Detailed, Ownable {

    using SafeMath for uint256;
    using SafeMathInt for int256;

    event LogRebase(uint256 indexed epoch, uint256 totalSupply);

    string public _name = "MilkShiba";
    string public _symbol = "MSHIB";
    uint8 public _decimals = 5;

    IDEXPair public pairContract;
    mapping(address => bool) _isFeeExempt;

    uint256 public constant DECIMALS = 5;
    uint256 public constant MAX_UINT256 = ~uint256(0);
    uint8 public constant RATE_DECIMALS = 7;

    uint256 private constant INITIAL_FRAGMENTS_SUPPLY =
        325 * 10**3 * 10**DECIMALS;

    uint256 public liquidityFeeBuy = 40;
    uint256 public spoiledMilkFeeBuy = 0;

    uint256 public liquidityFeeSell = 40;
    uint256 public spoiledMilkFeeSell = 20;

    uint256 public swapFeeBuy = 90;
    uint256 public swapFeeSell = 120;

    uint256 public milkTankShare = 30;    
    uint256 public milkWarShare = 30;    
    uint256 public milkBankShare = 40;
    uint256 public milkPupBountyPercent = 66;
    
    uint256 public totalFeeBuy =
        liquidityFeeBuy.add(swapFeeBuy).add(spoiledMilkFeeBuy);
        uint256 public totalFeeSell =
        liquidityFeeSell.add(swapFeeSell).add(spoiledMilkFeeSell);        
    uint256 public constant feeDenominator = 1000;
    IDEXRouter public router;
    address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
    address public constant ZERO = 0x0000000000000000000000000000000000000000;
    
    //ADA Mainnet
    address public USDAddress = address(0xB44a9B6905aF7c801311e8F4E76932ee959c663C);
    address public _routerAddress = address(0x9D2E30C2FB648BeE307EDBaFDb461b09DF79516C); 

    // //ADA Testnet
    // address public USDAddress = address(0xC12F6Ee5c853393105f29EF0310e61e6B494a70F);
    // address public _routerAddress = address(0x347e2a75e99174d46D94B5D7b4BE8f294bc2F5Fc); 
    
    
    using EnumerableSet for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet electedCouncil;
    EnumerableSet.AddressSet milkPups;

    address public milkShiba = ZERO;
    uint256 public milkShibaScore;
    address public milkPup = ZERO;
    uint256 public milkPupScore;

    uint256 public totalmilkPup;
    
    uint256 public timeLastMilkPup;
    uint256 public timeLastMilkShiba;
    uint256 public milkPupRoundDuration = 30 minutes;
    uint256 public milkShibaRoundDuration = 1 days;                  

    mapping(address => uint256) public timesAsmilkPup;
     
    mapping(address => uint256) public timesWinMilkBattle;  
    mapping(address => uint256) public timesWinBuy;  
    mapping(address => uint256) public maxWinBuy;  
    mapping(address => uint256) public winCouncilBuy; 
    mapping(address => uint256) public individualmilkShibaBounty;
    mapping(address => uint256) public individualmilkPupBounty;

    address public mostWinsmilkPup;
    uint256 public mostWinsAsmilkPup;    
 
    uint256 public totalmilkShibaBounty;
    uint256 public totalmilkPupBounty;

    mapping(address => bool) public fallenToGreed; 
    uint256 public totalFallenToGreed; 

    address public autoLiquidityFund;
    address public milkBank;
    address public milkTank;
    address public spoiledMilk;
    address public pairAddress;
    bool public swapEnabled = true;
    bool public useTradeLimits = true;
    
    address public pair;
    bool inSwap = false;
    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }

    uint256 private constant TOTAL_GONS =
        MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);

    uint256 private constant MAX_SUPPLY = 325 * 10**7 * 10**DECIMALS;

    uint256 public INDEX;

    bool public _autoRebase;
    bool public _autoAddLiquidity;
    uint256 public _initRebaseStartTime;
    uint256 public _lastRebasedTime;
    uint256 public _lastAddLiquidityTime;
    uint256 public _rebaseIncremenet = 0;
    uint256 public _rebaseCooldown;
    uint256 public _liquidityAddCooldown;
    
    uint256 public _totalSupply;
    uint256 public swapLimit;
    uint256 private _gonsPerFragment;

    mapping(address => uint256) private _gonBalances;
    mapping(address => mapping(address => uint256)) private _allowedFragments;
    mapping(address => bool) public blacklist;

    constructor() ERC20Detailed(_name, _symbol, uint8(DECIMALS)) Ownable() {

        
        router = IDEXRouter(_routerAddress); 

        pair = IDEXFactory(router.factory()).createPair(
            router.WETH(),
            address(this)
        );
        
        autoLiquidityFund = address(0x4548A20CAd4707Cbd38c205079bD9eD3c88aE103);
        milkBank =  msg.sender;
        milkTank =  address(0x47ca15f1E2bE671B0B26C2599A25F3e012a1A7ca);
        spoiledMilk = ZERO;

        _allowedFragments[address(this)][address(router)] = MAX_UINT256;
        pairAddress = pair;
        pairContract = IDEXPair(pair);

        _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
        swapLimit = 2 * _totalSupply / 1000;
        _gonBalances[milkBank] = TOTAL_GONS;
        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
        _initRebaseStartTime = block.timestamp;
        _lastRebasedTime = block.timestamp;
        _autoRebase = true;
        _autoAddLiquidity = true;
        _isFeeExempt[milkBank] = true;
        _isFeeExempt[address(this)] = true;

        INDEX = gonsForBalance(100000);

        _rebaseCooldown = 15 minutes;
        _liquidityAddCooldown = 15 minutes;           
        timeLastMilkShiba = block.timestamp;
        timeLastMilkPup = block.timestamp;

        _transferOwnership(milkBank);
        emit Transfer(address(0x0), milkBank, _totalSupply);
    }

    function rebase() internal {
        if ( inSwap ) return;
        uint256 rebaseRate;
        uint256 deltaTimeFromInit = block.timestamp - _initRebaseStartTime;
        uint256 deltaTime = block.timestamp - _lastRebasedTime;
        uint256 times = deltaTime.div(_rebaseCooldown);
        uint256 epoch = times.mul(_rebaseCooldown / 60);

        if (deltaTimeFromInit >= (8 * 365 days)) {
            rebaseRate = 8 + _rebaseIncremenet / 320;
        } else if (deltaTimeFromInit >= (5 * 365 days)) {
            rebaseRate = 33 + _rebaseIncremenet / 80;
        } else if (deltaTimeFromInit >= (3 * 365 days)) {
            rebaseRate = 62 + _rebaseIncremenet / 40;
        } else if (deltaTimeFromInit >= (2 * 365 days)) {
            rebaseRate = 125 + _rebaseIncremenet / 20;
        } else if (deltaTimeFromInit >= (365 days)) {
            rebaseRate = 224 + _rebaseIncremenet / 10;
        } else {
            rebaseRate = 2362 + _rebaseIncremenet;
        } 
        
        for (uint256 i = 0; i < times; i++) {
            _totalSupply = _totalSupply
                .mul((10**RATE_DECIMALS).add(rebaseRate))
                .div(10**RATE_DECIMALS);
        }

        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
        _lastRebasedTime = _lastRebasedTime.add(times.mul(_rebaseCooldown));

        pairContract.sync();

        emit LogRebase(epoch, _totalSupply);
    }

    function transfer(address to, uint256 value) external override returns (bool){
        _transferFrom(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external override returns (bool) {
        if (_allowedFragments[from][msg.sender] != MAX_UINT256) {
            _allowedFragments[from][msg.sender] = _allowedFragments[from][
                msg.sender
            ].sub(value, "Insufficient Allowance");
        }
        _transferFrom(from, to, value);
        return true;
    }

    function _basicTransfer(address from, address to, uint256 amount) internal returns (bool) {
        uint256 gonAmount = amount.mul(_gonsPerFragment);
        _gonBalances[from] = _gonBalances[from].sub(gonAmount);
        _gonBalances[to] = _gonBalances[to].add(gonAmount);
        return true;
    }

    function toggleTradeLimits(bool _useTradeLimits) external onlyOwner {
        useTradeLimits = _useTradeLimits;
    }

    function setSwapLimit(uint256 _swapLimit) external onlyOwner {
        swapLimit = _swapLimit;
    }
    
    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        require(!blacklist[sender] && !blacklist[recipient], "in_blacklist");

        if (inSwap) {
            return _basicTransfer(sender, recipient, amount);
        }

        if (shouldRebase()) {
           rebase();
        }

        if (shouldAddLiquidity()) {
            addLiquidity();
        }

        if (shouldSwapBack()) {
            swapBack();
        }

        uint256 gonAmount = amount.mul(_gonsPerFragment);
        if(useTradeLimits && sender != owner() && recipient != pair){
             require(_gonBalances[recipient].add(gonAmount) <= gonsForBalance(_totalSupply) / 50, "Initial 2% max wallet restriction");
        }

        _gonBalances[sender] = _gonBalances[sender].sub(gonAmount);
        uint256 gonAmountReceived;
        if(shouldTakeFee(sender, recipient)){
            gonAmountReceived = takeFee(sender, recipient, gonAmount);
            
            if(sender == pair){
                address[] memory path = new address[](2);
                path[0] = router.WETH();
                path[1] = address(this);
                uint256 buyAmountADA = router.getAmountsIn(amount, path)[0];

                if(block.timestamp > timeLastMilkPup + milkPupRoundDuration && milkPup != ZERO){
                    if(milkPups.contains(milkPup) == false){
                        milkPups.add(milkPup);                        
                    }
                    timesWinMilkBattle[milkPup] ++;
                    timesWinBuy[milkPup] += milkPupScore;
                    if(timesWinMilkBattle[milkPup] > mostWinsAsmilkPup){
                        mostWinsmilkPup = milkPup;
                        mostWinsAsmilkPup = timesWinMilkBattle[milkPup];
                    }
                    maxWinBuy[milkPup] = milkPupScore > maxWinBuy[milkPup] ? milkPupScore : maxWinBuy[milkPup];
                    milkPup = ZERO;
                    milkPupScore = 0;
                }
                if(block.timestamp > timeLastMilkShiba + milkShibaRoundDuration && milkShiba != ZERO){
                    if(electedCouncil.contains(milkShiba) == false){
                        electedCouncil.add(milkShiba);
                        winCouncilBuy[milkShiba] = milkShibaScore;
                    }                    
                    milkShiba = ZERO;
                    milkShibaScore = 0;
                }

                if(buyAmountADA > milkPupScore && !fallenToGreed[recipient]){                                    
                    if(timesAsmilkPup[recipient] == 0){
                        totalmilkPup++;                         
                    }                        
                    if(milkPup != recipient){
                        timesAsmilkPup[recipient]++;
                        milkPup = recipient;
                    }                    
                    milkPupScore = buyAmountADA;
                    timeLastMilkPup = block.timestamp;
                    if(buyAmountADA > milkShibaScore){ 
                        if(milkShiba != recipient){ 
                            milkShiba = recipient;
                        }
                        milkShibaScore = buyAmountADA;
                        timeLastMilkShiba = block.timestamp;
                    }
                }
            }
            else if(recipient == pair){
                if(sender == milkPup || sender == milkShiba){
                    fallenToGreed[sender] = true;
                    totalFallenToGreed++;                
                    if(sender == milkPup){                    
                        milkPup = ZERO;
                        milkPupScore = 0;
                        timeLastMilkPup = block.timestamp;                    
                    }    
                    if(sender == milkShiba){                    
                        milkShiba = ZERO;
                        milkShibaScore = 0;
                        timeLastMilkShiba = block.timestamp;
                    }  
                }
            }

        }
        else{             
            gonAmountReceived = gonAmount; 
        }
        _gonBalances[recipient] = _gonBalances[recipient].add(gonAmountReceived);


        emit Transfer(sender,recipient, gonAmountReceived.div(_gonsPerFragment));
        return true;
    }

    function takeFee(address sender, address recipient, uint256 gonAmount) internal  returns (uint256) {
        uint256 feeAmount;
        if (recipient == pair) {
            _gonBalances[spoiledMilk] = _gonBalances[spoiledMilk].add(
            gonAmount.div(feeDenominator).mul(spoiledMilkFeeSell)
            );
            _gonBalances[address(this)] = _gonBalances[address(this)].add(
                gonAmount.div(feeDenominator).mul(swapFeeSell)
            );
            _gonBalances[autoLiquidityFund] = _gonBalances[autoLiquidityFund].add(
                gonAmount.div(feeDenominator).mul(liquidityFeeSell)
            );
            feeAmount = gonAmount.div(feeDenominator).mul(totalFeeSell);    
        }
        else{   
            _gonBalances[spoiledMilk] = _gonBalances[spoiledMilk].add(
            gonAmount.div(feeDenominator).mul(spoiledMilkFeeBuy)
            );
            _gonBalances[address(this)] = _gonBalances[address(this)].add(
                gonAmount.div(feeDenominator).mul(swapFeeBuy)
            );
            _gonBalances[autoLiquidityFund] = _gonBalances[autoLiquidityFund].add(
                gonAmount.div(feeDenominator).mul(liquidityFeeBuy)
            );
            feeAmount = gonAmount.div(feeDenominator).mul(totalFeeBuy);
        }
       
        emit Transfer(sender, address(this), feeAmount.div(_gonsPerFragment));
        return gonAmount.sub(feeAmount);
    }

    function addLiquidity() internal swapping {        
        uint256 autoLiquidityAmount = _gonBalances[autoLiquidityFund].div(
            _gonsPerFragment
        );
        _gonBalances[address(this)] = _gonBalances[address(this)].add(
            _gonBalances[autoLiquidityFund]
        );
        _gonBalances[autoLiquidityFund] = 0;
        uint256 amountToLiquify = autoLiquidityAmount.div(2);
        uint256 amountToSwap = autoLiquidityAmount.sub(amountToLiquify);

        if( amountToSwap == 0 ) {
            return;
        }
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        uint256 balanceBefore = address(this).balance;
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );
        uint256 amountETHLiquidity = address(this).balance.sub(balanceBefore);

        if (amountToLiquify > 0 && amountETHLiquidity > 0) {
            router.addLiquidityETH{value: amountETHLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                autoLiquidityFund,
                block.timestamp
            );
        }
        _lastAddLiquidityTime = block.timestamp;
    }

    function swapBack() internal swapping {     
        uint256 amountToSwap = _gonBalances[address(this)].div(_gonsPerFragment);
        amountToSwap = amountToSwap >= swapLimit ? swapLimit : amountToSwap;
        if( amountToSwap == 0) {
            return;
        }
 
        uint256 milkBankTokens = amountToSwap * milkBankShare / 100;
        uint256 milkWarTokens = amountToSwap * milkWarShare / 100;
        uint256 milkTankTokens = amountToSwap - milkBankTokens - milkWarTokens;
        
        uint256 spoiledMilkAmount = 0;
        if(milkPupScore == 0 || milkShibaScore == 0){
            if(milkPupScore == 0){
                spoiledMilkAmount += milkPupBountyPercent * milkWarTokens / 100;                                
            }
            if(milkShibaScore == 0){
                spoiledMilkAmount += (100 - milkPupBountyPercent) * milkWarTokens / 100;                                
            }
            milkWarTokens -= spoiledMilkAmount;
             
            _gonBalances[spoiledMilk] = _gonBalances[spoiledMilk] + spoiledMilkAmount;
        }
        uint256 tokensToSwap = milkBankTokens + milkWarTokens + milkTankTokens;
        uint256 balanceBefore = address(this).balance;
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokensToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );
        uint256 amountETH = address(this).balance.sub(balanceBefore);

        if(milkPupScore != 0 || milkShibaScore != 0){
            uint256 bnbForBounty = amountETH * milkWarTokens / tokensToSwap; 
            if(milkPupScore != 0 && milkShibaScore != 0){
                uint256 bnbFormilkPup = milkPupBountyPercent * bnbForBounty / 100;
                uint256 bnbFormilkShiba = bnbForBounty - bnbFormilkPup;
                (bool temp,) = payable(milkShiba).call{value: bnbFormilkShiba, gas: 30000}("");                 
                (temp,) = payable(milkPup).call{value: bnbFormilkPup, gas: 30000}(""); 
                individualmilkShibaBounty[milkShiba] += bnbFormilkShiba;
                individualmilkPupBounty[milkPup] += bnbFormilkPup;
                totalmilkShibaBounty += bnbFormilkShiba;
                totalmilkPupBounty += bnbFormilkPup;                 
            }
            else if(milkPupScore != 0){
                (bool temp,) = payable(milkPup).call{value: bnbForBounty, gas: 30000}("");temp; //warning-suppresion                
                individualmilkPupBounty[milkPup] += bnbForBounty;
                totalmilkPupBounty += bnbForBounty;
            }
            else{
                (bool temp,) = payable(milkShiba).call{value: bnbForBounty, gas: 30000}("");temp;                
                individualmilkShibaBounty[milkShiba] += bnbForBounty;
                totalmilkShibaBounty += bnbForBounty;
            }
        }
        
        ( bool tempo,) = payable(milkBank).call{value: amountETH * milkBankTokens / tokensToSwap, gas: 30000}("");tempo; //warning-suppresion 
        (tempo, ) = payable(milkTank).call{value: address(this).balance, gas: 30000}("");
    }

    function withdrawAllTomilkBank() external swapping onlyOwner {
        uint256 amountToSwap = _gonBalances[address(this)].div(_gonsPerFragment);
        require( amountToSwap > 0,"There is no milkWar token deposited in token contract");
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            milkBank,
            block.timestamp
        );
    }

    function shouldTakeFee(address from, address to) internal view returns (bool){
        return (pair == from || pair == to) && !_isFeeExempt[to] && !_isFeeExempt[from];
    }

    function shouldRebase() internal view returns (bool) {
        return _autoRebase && (_totalSupply < MAX_SUPPLY) && msg.sender != pair &&
         !inSwap && block.timestamp >= (_lastRebasedTime + _rebaseCooldown);
    }

    function shouldAddLiquidity() internal view returns (bool) {
        return _autoAddLiquidity && !inSwap &&  msg.sender != pair &&
            block.timestamp >= (_lastAddLiquidityTime + _liquidityAddCooldown);
    }

    function shouldSwapBack() internal view returns (bool) {
        return !inSwap && msg.sender != pair; 
    }

    function setAutoRebase(bool _flag, uint256 rebaseCooldown, uint256 rebaseIncrement) external onlyOwner {
        if (_flag) {
            require(rebaseIncrement <= 268, "Upper APY cap at 1,003,975 %");
            require(rebaseCooldown >= 15 minutes && rebaseCooldown <= 18 minutes , "Lower APY cap at 98,853 %");
            _autoRebase = _flag;
            _lastRebasedTime = block.timestamp;
            _rebaseCooldown = rebaseCooldown;
            _rebaseIncremenet = rebaseIncrement;
        } else {
            _autoRebase = _flag;
        }
    }

    function setAutoAddLiquidity(bool _flag, uint256 liquidityAddCooldown) external onlyOwner {
        if(_flag) {
            require(liquidityAddCooldown >= 15 minutes && liquidityAddCooldown <= 2 days, "Liquidity injection cooldown restricted.");
            _autoAddLiquidity = _flag;
            _lastAddLiquidityTime = block.timestamp;
            _liquidityAddCooldown = liquidityAddCooldown;
        } else {
            _autoAddLiquidity = _flag;
        }
    }

    function allowance(address owner_, address spender) external view override returns (uint256) {
        return _allowedFragments[owner_][spender];
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
        uint256 oldValue = _allowedFragments[msg.sender][spender];
        if (subtractedValue >= oldValue) {
            _allowedFragments[msg.sender][spender] = 0;
        } else {
            _allowedFragments[msg.sender][spender] = oldValue.sub(
                subtractedValue
            );
        }
        emit Approval(
            msg.sender,
            spender,
            _allowedFragments[msg.sender][spender]
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
        _allowedFragments[msg.sender][spender] = _allowedFragments[msg.sender][
            spender
        ].add(addedValue);
        emit Approval(
            msg.sender,
            spender,
            _allowedFragments[msg.sender][spender]
        );
        return true;
    }

    function approve(address spender, uint256 value) external override returns (bool) {
        _allowedFragments[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function checkFeeExempt(address _addr) external view returns (bool) {
        return _isFeeExempt[_addr];
    }

    function getCirculatingSupply() public view returns (uint256) {
        return (TOTAL_GONS.sub(_gonBalances[spoiledMilk].sub(_gonBalances[DEAD])).sub(_gonBalances[ZERO]))
        .div(_gonsPerFragment);
    }

    function isNotInSwap() external view returns (bool) {
        return !inSwap;
    }

    function manualSync() external {
        IDEXPair(pair).sync();
    }

    function setFeeReceivers(address _autoLiquidityFund, address _milkBank, address _milkTank) external onlyOwner {
        autoLiquidityFund = _autoLiquidityFund;
        milkBank = _milkBank;
        milkTank = _milkTank;
    }

    function setFees(uint256 _liquidityFeeBuy, uint256 _liquidityFeeSell,
        uint256 _spoiledMilkFeeBuy, uint256 _spoiledMilkFeeSell,
        uint256 _swapFeeBuy, uint256 _swapFeeSell,
        uint256 _milkTankShare, uint256 _milkWarShare, uint256 _milkBankShare,
        uint256 _milkPupBountyPercent) external onlyOwner {

        require(_liquidityFeeBuy > 0 && _liquidityFeeSell > 0 && 
        _liquidityFeeBuy + _spoiledMilkFeeBuy + _swapFeeBuy <= 300 &&
         _liquidityFeeSell + _spoiledMilkFeeSell + _swapFeeSell <= 300, "Fees too high, 30% max.");
                
        require(_milkWarShare >= 30 && _milkPupBountyPercent >= 50, "Fighters need be paid.");
        assert(_milkTankShare + _milkWarShare + _milkBankShare == 100);

        liquidityFeeBuy = _liquidityFeeBuy;
        liquidityFeeSell = _liquidityFeeSell;

        spoiledMilkFeeBuy = _spoiledMilkFeeBuy;
        spoiledMilkFeeSell = _spoiledMilkFeeSell;

        swapFeeBuy = _swapFeeBuy;
        swapFeeSell = _swapFeeSell;

        milkTankShare = _milkTankShare;    
        milkWarShare = _milkWarShare;    
        milkBankShare = _milkBankShare;
        
        milkPupBountyPercent = _milkPupBountyPercent;
        
        totalFeeBuy =
            liquidityFeeBuy.add(swapFeeBuy).add(spoiledMilkFeeBuy);
        totalFeeSell =
            liquidityFeeSell.add(swapFeeSell).add(spoiledMilkFeeSell); 

    }

    function setmilkPupRound(uint256 _milkPupRoundDuration) external onlyOwner {
        require(_milkPupRoundDuration >= 15 minutes && _milkPupRoundDuration <= 1 hours, "Duration of rounds in milkWar restricted.");
        milkPupRoundDuration = _milkPupRoundDuration;
    }

    function setWhitelist(address _addr) external onlyOwner {
        _isFeeExempt[_addr] = true;
    }

    function setBotBlacklist(address _botAddress, bool _flag) external onlyOwner {
        require(isContract(_botAddress), "Only contract address, not allowed externally owned account");
        blacklist[_botAddress] = _flag;    
    }
    
    function setPairAddress(address _pairAddress) external onlyOwner {
        pairAddress = _pairAddress;
    }

    function setLP(address _address) external onlyOwner {
        pairContract = IDEXPair(_address);
    }
    
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }
   
    function balanceOf(address who) external view override returns (uint256) {
        return _gonBalances[who].div(_gonsPerFragment);
    }

    function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }

    function gonsForBalance(uint256 amount) public view returns (uint256) {
        return amount.mul(_gonsPerFragment);
    }

    function balanceForGons(uint256 gons) public view returns (uint256) {
        return gons.div(_gonsPerFragment);
    }

    function index() public view returns (uint256) {
        return balanceForGons(INDEX);
    }


    struct MilkBattleOracleData{
        address  milkShiba;
        uint256  milkShibaScore;
        address  milkPup;
        uint256  milkPupScore;

        uint256  timeLastMilkPup;
        uint256  timeLastMilkShiba;
    
        address  mostWinsmilkPup;
        uint256  mostWinsAsmilkPup;
    
        uint256  totalFighters;
        uint256  totalmilkPup;
        uint256  totalmilkShiba;
        uint256  totalmilkShibaBounty;
        uint256  totalmilkPupBounty;
        uint256  totalFallenToGreed; 

        uint256 liquidity;
        uint256 milkBank;
        uint256 spoiledMilk;

        uint256 lastRebasedTime;

    }
function getMilkBattleOracleData() external view returns(MilkBattleOracleData memory){
        MilkBattleOracleData memory data = MilkBattleOracleData(
            milkShiba, milkShibaScore, milkPup, milkPupScore,
            timeLastMilkPup, timeLastMilkShiba, 
            mostWinsmilkPup, mostWinsAsmilkPup, totalmilkPup,
            milkPups.length(), electedCouncil.length(), totalmilkShibaBounty, totalmilkPupBounty,
            totalFallenToGreed, getPairValue(), milkBank.balance, getspoiledMilkValue(), _lastRebasedTime);
            return data;
    }
     

    struct MilkBattleOracleDataWallet{
        bool inCouncil;
        uint256 timesWinMilkBattle;
        uint256 timesWinBuy;
        
        bool fallenToGreed;      
        uint256 individualAresBounty;
        uint256 individualmilkPupBounty;

        uint256  maxWinBuy;
        uint256  winCouncilBuy;
    }  

    

     function getMilkBattleOracleDataWallet(address wallet) external view returns (MilkBattleOracleDataWallet memory){
        MilkBattleOracleDataWallet memory data = MilkBattleOracleDataWallet(
            electedCouncil.contains(wallet), timesWinMilkBattle[wallet],  timesWinBuy[wallet],
            fallenToGreed[wallet], individualmilkShibaBounty[wallet], individualmilkPupBounty[wallet],
            maxWinBuy[wallet], winCouncilBuy[wallet]);        
             return data;
    }

    function getEstimatedUSD(uint256 amount, bool fromToken) public view returns (uint256){        
        if(fromToken){
            address[] memory path = new address[](3);
            path[0] = USDAddress;        
            path[1] = router.WETH();
            path[2] = address(this);
            return router.getAmountsIn(amount, path)[0];
        }else{
            address[] memory path = new address[](2);
            path[0] = USDAddress;        
            path[1] = router.WETH();            
            return router.getAmountsIn(amount, path)[0];
        }                
    }

    function getspoiledMilkValue() public view returns (uint256){
        if(this.balanceOf(ZERO) == 0){
            return 0;
        }
        else{
            return getEstimatedUSD(this.balanceOf(ZERO), true);
        }       
    }

    function getPairValue() public view returns (uint256){               
        return getEstimatedUSD(IERC20(router.WETH()).balanceOf(pair), false);
    }

    function getMilkPupAt(uint256 _index) external view returns(address) {
        return milkPups.at(_index);
    }

    function getMilkShibaAt(uint256 _index) external view returns(address) {
        return electedCouncil.at(_index);
    }

    function getmilkPupCount() external view returns(uint256) {
        return milkPups.length();
    }

    function getMilkShibaCount() external view returns(uint256) {
        return electedCouncil.length();
    }

    receive() external payable {}
}
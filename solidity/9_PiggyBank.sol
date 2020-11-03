pragma solidity >=0.6.0;
pragma AbiHeader expire;

contract PiggyBank {
	// contract owner's address;
	address owner;
	// piggybank's minimal limit to withdraw;
	uint limit;
	// piggybank's deposit balance.
	uint128 balance;

	// Constructor saves the address of the contract owner in a state variable and
	// initializes the limit and the balance.
	constructor(address own, uint lim) public {
		// Check that contract have pubkey
		require(tvm.pubkey() != 0, 101);
		// Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		owner = own;
		limit = lim;
		balance = 0;
	}

	// Modifier that allows public function to be called only when the limit is reached.
	modifier checkBalance() {
		require(balance >= limit, 103);
		_;
	}

	// Modifier that allows public function to be called only from the owners address.
	modifier checkSenderIsOwner {
		require(msg.sender == owner, 101);
		_;
	}

	// Function that can be called by anyone.
	function deposit() public {
		balance += uint128(msg.value);
	}

	// Function that can be called only by the owner after reaching the limit.
	function withdraw() public checkSenderIsOwner checkBalance {
		tvm.accept();
		msg.sender.transfer(balance);
		balance = 0;
	}

	/*
	 * Public Getters
	 */
	function getData() public returns (address own, uint lim, uint128 bal) {
		return (owner, limit, balance);
	}
}

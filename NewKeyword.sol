// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// AddressBook Contract
contract AddressBook is Ownable {
    constructor(address initialOwner) Ownable(initialOwner) {}

    struct Contact {
        uint256 id;
        string firstName;
        string lastName;
        uint256[] phoneNumbers;
    }

    mapping(uint256 => Contact) private contacts;
    uint256 private contactIdCounter;

    error ContactNotFound(uint256 id);

    event ContactAdded(uint256 id, string firstName, string lastName);

    event ContactDeleted(uint256 id);

    function addContact(
        string memory _firstName,
        string memory _lastName,
        uint256[] memory _phoneNumbers
    ) public onlyOwner {
        contactIdCounter++;
        contacts[contactIdCounter] = Contact(
            contactIdCounter,
            _firstName,
            _lastName,
            _phoneNumbers
        );
        emit ContactAdded(contactIdCounter, _firstName, _lastName);
    }

    function deleteContact(uint256 _id) public onlyOwner {
        if (contacts[_id].id == 0) {
            revert ContactNotFound(_id);
        }
        delete contacts[_id];
        emit ContactDeleted(_id);
    }

    function getContact(uint256 _id) public view returns (Contact memory) {
        if (contacts[_id].id == 0) {
            revert ContactNotFound(_id);
        }
        return contacts[_id];
    }

    // For bonus points (that only you will know about), explain why we can't just use the automatically generated getter for contacts?
    // Contact contains uint[] so we can't generate a getter code for dynamic array types inside mappings
    function getAllContacts() public view returns (Contact[] memory) {
        uint256 count = 0;

        for (uint256 i = 1; i <= contactIdCounter; i++) {
            if (contacts[i].id != 0) {
                count++;
            }
        }

        Contact[] memory allContacts = new Contact[](count);
        uint256 index = 0;

        for (uint256 i = 1; i <= contactIdCounter; i++) {
            if (contacts[i].id != 0) {
                allContacts[index] = contacts[i];
                index++;
            }
        }

        return allContacts;
    }
}

contract AddressBookFactory {
    event AddressBookDeployed(address indexed newAddressBook);

    function deploy() public returns (address) {
        AddressBook newAddressBook = new AddressBook(msg.sender);
        emit AddressBookDeployed(address(newAddressBook));
        return address(newAddressBook);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Ownable.sol";

error Library__InvalidBookId(uint256 id);
error Library__NoCopiesAvailable();
error Library__BookAlreadyBorrowedByYou();

error Library__YouHaventBorrowedThisBook(uint256 id);

contract Library is Ownable {

    uint256 public bookCount;

    struct Book {
        uint256 id;
        string name;
        uint16 copies;
    }

    mapping (uint256 => Book) public books;
    mapping(uint256 => mapping(address => bool)) public borrowed;
    mapping (uint256 => address[]) private borrowers;

    Book[] private bookArray;

    event newBookAdded(uint256 indexed id, string indexed name, uint16 copies);
    event bookBorrowed(address indexed borrower, uint256 indexed id);
    event bookReturned(address indexed borrower, uint256 indexed id);

    function addNewBook(string calldata _name, uint16 _copies) public onlyOwner returns(uint256) {
        ++bookCount;

        Book memory book =  Book(
            bookCount,
            _name,
            _copies
        );

        books[bookCount] = book;
        bookArray.push(book);

        emit newBookAdded(book.id, _name, _copies);

        return bookCount;
    }

    function borrowBook(uint256 _id) public {
        if (books[_id].id == 0) revert Library__InvalidBookId(_id);
        
        if (books[_id].copies == 0) revert Library__NoCopiesAvailable();

        if (borrowed[_id][msg.sender] == true) revert Library__BookAlreadyBorrowedByYou();

        --books[_id].copies;
        borrowed[_id][msg.sender] = true;
        borrowers[_id].push(msg.sender);

        emit bookBorrowed(msg.sender, _id);
    }

    function returnBook(uint256 _id) public {
        if (borrowed[_id][msg.sender] == false) revert Library__YouHaventBorrowedThisBook(_id);

        ++books[_id].copies;
        borrowed[_id][msg.sender] = false;

        emit bookReturned(msg.sender, _id);
    }

    function getBorrowers(uint _id) public view returns (address[] memory) {
        return borrowers[_id];
    }

    function getBooks() public view returns(Book[] memory) {
        return bookArray;
    }
}
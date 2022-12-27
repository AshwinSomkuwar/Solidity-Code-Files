// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract SupplyChain {
    uint32 public product_id = 0;  // Product ID
    uint32 public participant_id = 0;  // Participant ID
    uint32 public owner_id = 0;  // Owner ID

    struct Product {
        string modelNumber;
        string partNumber;
        string serialNumber;
        address productOwner;
        uint32 cost;
        uint32 mfgTimestamp;
    }

    mapping(uint32 => Product) public products;

    struct Participant {
        string userName;
        string password;
        string participantType;
        address participantAddress;
    }

    mapping(uint32 => Participant) public participants;

    // This struct connects the product with the owner
    struct Ownership {
        uint32 productId;
        uint32 ownerId;
        uint32 trxTimestamp;
        address productOwner;
    }

    mapping(uint32 => Ownership) public ownerships;  // ownerships by ownership ID (owner_id)
    mapping(uint32 => uint32[]) public productTrack;  // ownerships by Product ID (product_id) / Movement tracking for a product
    // ....
    event TransferOwnership(uint32 productId);

    function addParticipants(string memory _name, string memory _pass, address _pAdd, string memory _pType) public returns (uint32) {
        uint32 usedId = participant_id++;
        participants[usedId].userName = _name;
        participants[usedId].password = _pass;
        participants[usedId].participantAddress = _pAdd;
        participants[usedId].participantType = _pType;

        return usedId;
    }   

    function getParticipants(uint32 _participant_id) public view returns (string memory, address, string memory) {
        return (participants[_participant_id].userName,
                participants[_participant_id].participantAddress,
                participants[_participant_id].participantType);
    }

    function addProduct(uint32 _ownerId,
                        string memory _modelNumber,
                        string memory _partNumber,
                        string memory _serialNumber,
                        uint32 _productCost) public returns (uint32) {
        // comparing the two strings with the help of Keccak256
        if (keccak256(abi.encodePacked(participants[_ownerId].participantType)) == keccak256("Manufacturer")) {
            uint32 productId = product_id++;

            products[productId].modelNumber = _modelNumber;
            products[productId].partNumber = _partNumber;
            products[productId].serialNumber = _serialNumber;
            products[productId].cost = _productCost;
            products[productId].productOwner = participants[owner_id].participantAddress;
            products[productId].mfgTimestamp = uint32(block.timestamp);

            return productId;
        }
        return 0;
    }

    modifier onlyOwner(uint32 _productId) {
        require(msg.sender == products[_productId].productOwner, "");
        _;
    }

    function getProduct(uint32 _productId) public view returns (string memory, string memory, string memory, uint32, address, uint32) {
        return (products[_productId].modelNumber,
                products[_productId].partNumber,
                products[_productId].serialNumber,
                products[_productId].cost,
                products[_productId].productOwner,
                products[_productId].mfgTimestamp);
    }

    function newOwner(uint32 _user1Id, uint32 _user2Id, uint32 _prodId) onlyOwner(_prodId) public returns (bool) {
        Participant memory p1 = participants[_user1Id];
        Participant memory p2 = participants[_user2Id];
        uint32 ownership_id = owner_id++;

        if (keccak256(abi.encodePacked(p1.participantType)) == keccak256("Manufacturer") && 
            keccak256(abi.encodePacked(p2.participantType)) == keccak256("Supplier")) {
                ownerships[ownership_id].productId = _prodId;
                ownerships[ownership_id].productOwner = p2.participantAddress;
                ownerships[ownership_id].ownerId = _user2Id;
                ownerships[ownership_id].trxTimestamp = uint32(block.timestamp);
                products[_prodId].productOwner = p2.participantAddress;
                productTrack[_prodId].push(ownership_id);

                emit TransferOwnership(_prodId);

                return true;
            }
            else if (keccak256(abi.encodePacked(p1.participantType)) == keccak256("Supplier") &&
                    keccak256(abi.encodePacked(p2.participantType)) == keccak256("Supplier")) {
                        ownerships[ownership_id].productId = _prodId;
                        ownerships[ownership_id].productOwner = p2.participantAddress;
                        ownerships[ownership_id].ownerId = _user2Id;
                        ownerships[ownership_id].trxTimestamp = uint32(block.timestamp);
                        products[_prodId].productOwner = p2.participantAddress;
                        productTrack[_prodId].push(ownership_id);

                        emit TransferOwnership(_prodId);

                        return true;
            }
            else if (keccak256(abi.encodePacked(p1.participantType)) == keccak256("Supplier") &&
                    keccak256(abi.encodePacked(p2.participantType)) == keccak256("Consumer")) {
                        ownerships[ownership_id].productId = _prodId;
                        ownerships[ownership_id].productOwner = p2.participantAddress;
                        ownerships[ownership_id].ownerId = _user2Id;
                        ownerships[ownership_id].trxTimestamp = uint32(block.timestamp);
                        products[_prodId].productOwner = p2.participantAddress;
                        productTrack[_prodId].push(ownership_id);

                        emit TransferOwnership(_prodId);

                        return true;
            }
            return false;
    }

    function getProvenance(uint32 _prodId) external view returns (uint32[] memory) {
        return productTrack[_prodId];
    }

    function getOwnership(uint32 _regId) public view returns (uint32, uint32, address, uint32) {
        Ownership memory r = ownerships[_regId];
        return (r.productId, r.ownerId, r.productOwner, r.trxTimestamp);
    }

    function authenticateParticipant(uint32 _uid,
                                    string memory _uname,
                                    string memory _pass,
                                    string memory _utype) public view returns (bool) {
                                        if (keccak256(abi.encodePacked(participants[_uid].participantType)) == keccak256(abi.encodePacked(_utype))) {
                                            if (keccak256(abi.encodePacked(participants[_uid].userName)) == keccak256(abi.encodePacked(_uname))) {
                                                if (keccak256(abi.encodePacked(participants[_uid].password)) == keccak256(abi.encodePacked(_pass))) {
                                                    return true;
                                                }
                                            }
                                        }
                                        return false;
    }
}
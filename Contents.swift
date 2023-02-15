import UIKit

// BINARY SEARCH -----------------------------------------------------------------------------------------------------------------------------------------

let array = [1,2,4,6,8,9,11,13,16,17,20]

func binarySearch(searchValue: Int, array: [Int]) -> Bool {
    var leftIndex = 0
    var rightIndex = array.count - 1

    while leftIndex <= rightIndex {

        let middleIndex = (leftIndex + rightIndex) / 2
        let middleValue = array[middleIndex]

        if searchValue == middleValue {
            return true
        }

        if searchValue < middleValue {
            rightIndex = middleIndex - 1
        }

        if searchValue > middleValue {
            leftIndex = middleIndex + 1
        }
    }
    return false
}

print(binarySearch(searchValue: 10, array: array))

// LINEAR SEARCH -----------------------------------------------------------------------------------------------------------------------------------------

func linearSearch(searchValue: Int, array: [Int]) -> Bool {
    for i in array {
        if i == searchValue {
            return true
        }
    }
    return false
}

print(linearSearch(searchValue: 10, array: array))

// LINKED LIST -----------------------------------------------------------------------------------------------------------------------------------------

class NodeList {
    let value: Int
    var next: NodeList?

    init(value: Int, next: NodeList?) {
        self.value = value
        self.next = next
    }
}

class LinkedList {

    var head: NodeList?

    func setupDummyNodes() {
        let three = NodeList(value: 3, next: nil)
        let two = NodeList(value: 2, next: three)
        head = NodeList(value: 1, next: two)
    }

    func displayListItems() {
        print("Here is whats inside of your list:")
        var current = head
        while current != nil {
            print(current?.value ?? "")
            current = current?.next
        }
    }

    func insert(value: Int) {
        // empty list
        if head == nil {
            head = NodeList(value: value, next: nil)
            return
        }

        var current = head
        while current?.next != nil {
            current = current?.next
        }
        current?.next = NodeList(value: value, next: nil)
    }

    // #2 Delete
    func delete(value: Int) {
        if head?.value == value {
            head = head?.next
        }

        var prev: NodeList?
        var current = head

        while current != nil && current?.value != value  {
            prev = current
            current = current?.next
        }

        prev?.next = current?.next
    }

    // "Special Insert"
    // // 1 -> 2 -> 4 -> 5 -> nil
    func insertInOrder(value: Int) {
        if head == nil || head?.value ?? Int.min >= value {
            let newNode = NodeList(value: value, next: head)
            head = newNode
            return
        }
        var currentNode: NodeList? = head
        while currentNode?.next != nil && currentNode?.next?.value ?? Int.min < value {
            currentNode = currentNode?.next
        }

        currentNode?.next = NodeList(value: value, next: currentNode?.next)
    }
}

let sampleList = LinkedList()
//sampleList.setupDummyNodes()
sampleList.insert(value: 1)
sampleList.insert(value: 2)
sampleList.insert(value: 4)
sampleList.insert(value: 5)
sampleList.insertInOrder(value: 3)
sampleList.displayListItems()


// BINARY TREE -----------------------------------------------------------------------------------------------------------------------------------------

// 1.
//          10
//         /  \
//        5    14
//       /    /  \
//      1    11   20

// 2.
class Node {
    let value: Int
    var leftChild: Node?
    var rightChild: Node?

    init(value: Int, leftChild: Node?, rightChild: Node?) {
        self.value = value
        self.leftChild = leftChild
        self.rightChild = rightChild
    }
}

//left branch
let oneNode = Node(value: 1, leftChild: nil, rightChild: nil)
let fiveNode = Node(value: 5, leftChild: oneNode, rightChild: nil)

//right branch
let elevenNode = Node(value: 11, leftChild: nil, rightChild: nil)
let twentyNode = Node(value: 20, leftChild: nil, rightChild: nil)
let fourteenNode = Node(value: 14, leftChild: elevenNode, rightChild: twentyNode)

let tenRootNode = Node(value: 10, leftChild: fiveNode, rightChild: fourteenNode)

//          10
//         /  \
//        5    14
//       /    /  \
//      1    11   20

// 3.
//Interviewer's question: Implement a search algorithm that searches through this tree for a particular searchValue
func search(node: Node?, searchValue: Int) -> Bool {
    if node == nil {
        return false
    }

    if node?.value == searchValue {
        return true
    } else if searchValue < node!.value {
        return search(node: node?.leftChild, searchValue: searchValue)
    } else {
        return search(node: node?.rightChild, searchValue: searchValue)
    }
}

search(node: tenRootNode, searchValue: 30)

// 4.
//What is the point of all this?

//let's talk about efficiency
let list = [1, 5, 10, 11, 14, 20]
let index = list.firstIndex(where: {$0 == 30})

// Morris, t = O(N), both average & worst s = O(1)
func inorderTraversal(_ r: Node?) -> [Int] {
    var root = r
    if root == nil {
        return []
    } else {
        var res: [Int] = []
        var pre: Node? = nil
        while root != nil {
            if root?.leftChild == nil {
                res.append((root?.value)!)
                root = root?.rightChild
            } else {
                pre = root?.leftChild
                while pre?.rightChild != nil && pre?.rightChild! !== root {
                    pre = pre?.rightChild
                }
                if pre?.rightChild == nil {
                    pre?.rightChild = root
                    root = root?.leftChild
                } else {
                    pre?.rightChild = nil
                    res.append((root?.value)!)
                    root = root?.rightChild
                }
            }
        }
        return res
    }
}

print(inorderTraversal(tenRootNode))

// Recursion, t = O(N), average s = O(log(N)), worst s = O(N)

func inorderTraversal_recursion_helper(root: Node?, arr: inout [Int]) {
    guard let root = root else { return }
    inorderTraversal_recursion_helper(root: root.leftChild, arr: &arr)
    arr.append(root.value)
    inorderTraversal_recursion_helper(root: root.rightChild, arr: &arr)
}

func inorderTraversal_recursion(_ root: Node?) -> [Int] {
    var res: [Int] = []
    inorderTraversal_recursion_helper(root: root, arr: &res)
    return res
}

print(inorderTraversal_recursion(tenRootNode))

// Recursion, t = O(N), average s = O(log(N)), worst s = O(N)

func preorderTraversal_recursion_helper(root: Node?, arr: inout [Int]) {
    guard let root = root else { return }
    arr.append(root.value)
    preorderTraversal_recursion_helper(root: root.leftChild, arr: &arr)
    preorderTraversal_recursion_helper(root: root.rightChild, arr: &arr)
}

func preorderTraversal_recursion(_ root: Node?) -> [Int] {
    var res: [Int] = []
    preorderTraversal_recursion_helper(root: root, arr: &res)
    return res
}

print(preorderTraversal_recursion(tenRootNode))

// Recursion, t = O(N), average s = O(log(N)), worst s = O(N)

func postorderTraversal_recursion_helper(root: Node?, arr: inout [Int]) {
    guard let root = root else { return }
    postorderTraversal_recursion_helper(root: root.leftChild, arr: &arr)
    postorderTraversal_recursion_helper(root: root.rightChild, arr: &arr)
    arr.append(root.value)
}

func postorderTraversal_recursion(_ root: Node?) -> [Int] {
    var res: [Int] = []
    postorderTraversal_recursion_helper(root: root, arr: &res)
    return res
}

print(postorderTraversal_recursion(tenRootNode))

// GENERIC STACK -----------------------------------------------------------------------------------------------------------------------------------------

class NodeStack<T> {
    let value: T
    var next: NodeStack?
    init(value: T) {
        self.value = value
    }
}

class Stack<T> {
    var top: NodeStack<T>?

    func push(_ value: T) {
        let oldTop = top
        top = NodeStack(value: value)
        top?.next = oldTop
    }

    func pop() -> T? {
        let currentTop = top
        top = top?.next
        return currentTop?.value
    }

    func peek() -> T? {
        return top?.value
    }
}

// LIFO STACK -----------------------------------------------------------------------------------------------------------------------------------------

print(lifoStack(arr : ["1","2","+","4","*"]))
print(lifoStack(arr : ["3","*","+","5","6"]))
print(lifoStack(arr : ["0","3","5","+","*","6","8","/","3","+","*"]))

func lifoStack(arr: [String]) -> String {
    var stackNumber: [String] = []
    var stackOperation: [String] = []
    var result = ""

    for i in arr {
        if isOperation(i) {
            stackOperation.append(i)
            if result != "" {
                let pop1 = stackNumber.popLast()
                let popOperation = stackOperation.popLast()
                result += " \(popOperation ?? "") \(pop1 ?? "")"
            } else {
                if stackNumber.count > 1 {
                    let pop1 = stackNumber.popLast()
                    let pop2 = stackNumber.popLast()
                    let popOperation = stackOperation.popLast()
                    result += "\(pop1 ?? "") \(popOperation ?? "") \(pop2 ?? "")"
                }
            }
        } else {
            stackNumber.append(i)
            if stackOperation.count > 1 {
                let pop1 = stackNumber.popLast()
                let pop2 = stackNumber.popLast()
                let popOperation = stackOperation.popLast()
                result += "\(pop1 ?? "") \(popOperation ?? "") \(pop2 ?? "")"
            } else {
                if result != "" && stackOperation.count != 0 {
                    let pop1 = stackNumber.popLast()
                    let popOperation = stackOperation.popLast()
                    result += " \(popOperation ?? "") \(pop1 ?? "")"
                }
            }
        }
    }
    return result
}

func isOperation(_ value: String) -> Bool {
    if String("+-*/").contains(value) {
        return true
    }
    return false
}

// Graph

class GraphNode: Hashable, Equatable {
    // Need hashable if we want to use SET DS
    static func == (lhs: GraphNode, rhs: GraphNode) -> Bool {
        return lhs.value == rhs.value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    var value: Int
    var neighbors: [GraphNode]

    init(_ value: Int, _ neighbors: [GraphNode] = []) {
        self.value = value
        self.neighbors = neighbors
    }
}

class Graph {
    var nodes: [GraphNode]

    init(_ nodes: [GraphNode] = []) {
        self.nodes = nodes
    }

    func addNode(_ value: GraphNode) {
        nodes.append(value)
    }

    func addEdge(_ node1: GraphNode, _ node2: GraphNode) {
        node1.neighbors.append(node2)
        node2.neighbors.append(node1)
    }
}

let node1 = GraphNode(1)
let node2 = GraphNode(2)
let node3 = GraphNode(3)

let graph = Graph()
graph.addNode(node1)
graph.addNode(node2)
graph.addNode(node3)

graph.addEdge(node1, node2)
graph.addEdge(node2, node3)

for node in graph.nodes {
    print("Node \(node.value) has neighbors:")
    for neighbor in node.neighbors {
        print("  \(neighbor.value)")
    }
}


// Breadth First Search

/*
 
 BFS (breadth-first search) and DFS (depth-first search) are two commonly used algorithms for traversing a graph. The purpose of these algorithms is to visit all the nodes in the graph, starting from a specified starting node, and visiting each node only once.

 BFS works by exploring all the neighbors of the starting node before moving on to the neighbors of its neighbors. In other words, it visits all the nodes at the same "level" before moving on to the nodes at the next level. To implement BFS, we can use a queue data structure to keep track of the nodes that we need to visit. We start by enqueueing the starting node, and then we repeat the following steps:

 1. Dequeue a node from the queue.
 2. Mark the node as visited.
 3. Enqueue all the unvisited neighbors of the node.
 
 We continue this process until the queue is empty, at which point we have visited all the nodes in the graph.
 
 This code creates an empty queue, an empty set to keep track of visited nodes, and an empty array to store the result of the traversal. It starts by enqueuing the starting node, and adding it to the visited set. It then enters a loop that continues as long as there are nodes in the queue. In each iteration of the loop, it dequeues a node from the front of the queue, adds it to the result array, and enqueues all its unvisited neighbors. It also adds each neighbor to the visited set to avoid visiting the same node twice.
 
 it can be used to find the shortest path
 
 */

func bfs(_ graph: [Int: [Int]], startNode: Int) -> [Int] {
    var visited = [Int]()
    var queue = [startNode]
    
    while !queue.isEmpty {
        let node = queue.removeFirst()
        if !visited.contains(node) {
            visited.append(node)
            if let neighbors = graph[node] {
                queue.append(contentsOf: neighbors)
            }
        }
    }
    
    return visited
}

// using object

//func bfs(startNode: GraphNode) -> [GraphNode] {
//    var queue = Queue<GraphNode>()
//    var visited = Set<GraphNode>()
//    var result = [GraphNode]()
//
//    queue.enqueue(startNode)
//    visited.insert(startNode)
//
//    while let node = queue.dequeue() {
//        result.append(node)
//
//        for neighbor in node.neighbors {
//            if !visited.contains(neighbor) {
//                queue.enqueue(neighbor)
//                visited.insert(neighbor)
//            }
//        }
//    }
//
//    return result
//}

// Depth First Search

/*
 
 DFS, on the other hand, works by exploring as far as possible along each branch before backtracking. In other words, it visits the neighbors of a node one by one, and recursively explores each neighbor before moving on to the next one. To implement DFS, we can use a stack data structure to keep track of the nodes that we need to visit. We start by pushing the starting node onto the stack, and then we repeat the following steps:

 1. Pop a node from the stack.
 2. Mark the node as visited.
 3. Push all the unvisited neighbors of the node onto the stack.
 
 We continue this process until the stack is empty, at which point we have visited all the nodes in the graph.
 
 This code creates an empty stack, an empty set to keep track of visited nodes, and an empty array to store the result of the traversal. It starts by pushing the starting node onto the stack. It then enters a loop that continues as long as there are nodes in the stack. In each iteration of the loop, it pops a node from the top of the stack, checks if it has already been visited, and if it hasn't, adds it to the visited set and the result array. It then pushes all the unvisited neighbors of the node onto the stack, so that they will be visited in the next iteration of the loop.
 
 It's worth noting that both BFS and DFS have time complexity O(V + E), where V is the number of nodes in the graph and E is the number of edges. However, BFS typically requires more memory than DFS, since it needs to keep track of all the nodes at a given "level" before moving on to the next level, whereas DFS only needs to keep track of the current path of nodes.
 
 */

func dfs(_ graph: [Int: [Int]], startNode: Int) -> [Int] {
    var visited = [Int]()
    
    func explore(_ node: Int) {
        visited.append(node)
        if let neighbors = graph[node] {
            for neighbor in neighbors {
                if !visited.contains(neighbor) {
                    explore(neighbor)
                }
            }
        }
    }
    
    explore(startNode)
    return visited
}

// using object

//func dfs(startNode: GraphNode) -> [GraphNode] {
//    var stack = Stack<GraphNode>()
//    var visited = Set<GraphNode>()
//    var result = [GraphNode]()
//
//    stack.push(startNode)
//
//    while let node = stack.pop() {
//        if !visited.contains(node) {
//            visited.insert(node)
//            result.append(node)
//
//            for neighbor in node.neighbors {
//                stack.push(neighbor)
//            }
//        }
//    }
//
//    return result
//}

/*
 
 1 -- 2
 |    | \
 |    |  5
 |    | /
 3    4
 
 */

let graph: [Int: [Int]] = [
    1: [2, 3],
    2: [1, 4, 5],
    3: [1],
    4: [2, 5],
    5: [2, 4]
]

// BFS traversal
print("BFS traversal:")
let bfsTraversal = bfs(graph, startNode: 1)
for node in bfsTraversal {
    print(node)
}

// DFS traversal
print("DFS traversal:")
let dfsTraversal = dfs(graph, startNode: 1)
for node in dfsTraversal {
    print(node)
}

//let node1 = GraphNode(1)
//let node2 = GraphNode(2)
//let node3 = GraphNode(3)
//let node4 = GraphNode(4)
//let node5 = GraphNode(5)
//
//let graph = Graph()
//graph.addNode(node1)
//graph.addNode(node2)
//graph.addNode(node3)
//graph.addNode(node4)
//graph.addNode(node5)
//
//graph.addEdge(node1, node2)
//graph.addEdge(node1, node3)
//graph.addEdge(node2, node4)
//graph.addEdge(node2, node5)
//graph.addEdge(node3, node5)
//
//// BFS traversal
//print("BFS traversal:")
//let bfsTraversal = bfs(startNode: node1)
//for node in bfsTraversal {
//    print(node.value)
//}
//
//// DFS traversal
//print("DFS traversal:")
//let dfsTraversal = dfs(startNode: node1)
//for node in dfsTraversal {
//    print(node.value)
//}


struct Queue<T> {
    private var elements: [T] = []

    mutating func enqueue(_ element: T) {
        elements.append(element)
    }

    mutating func dequeue() -> T? {
        guard !elements.isEmpty else { return nil }
        return elements.removeFirst()
    }

    var isEmpty: Bool {
        return elements.isEmpty
    }

    var count: Int {
        return elements.count
    }

    var front: T? {
        return elements.first
    }
}

struct Stack<T> {
    private var elements: [T] = []

    mutating func push(_ element: T) {
        elements.append(element)
    }

    mutating func pop() -> T? {
        return elements.popLast()
    }

    var isEmpty: Bool {
        return elements.isEmpty
    }

    var count: Int {
        return elements.count
    }

    var top: T? {
        return elements.last
    }
}

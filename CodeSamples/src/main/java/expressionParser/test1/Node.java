package expressionParser.test1;

public class Node {
    Node left;
    Node right;
    String data;

    public Node() {}

    public Node(String data) {
        this.data = data;
    }

    public void preorderTraversal(Node n) {
        System.out.println(n.data);
        if (n.left != null)
            n.preorderTraversal(n.left);
        if (n.right != null)
            n.preorderTraversal(n.right);
    }

    public void inorderTraversal(Node n) {
        if (n.left != null) {
            n.inorderTraversal(n.left);
        }
        System.out.println(n.data);
        if (n.right != null) {
            n.inorderTraversal(n.right);
        }
    }

    public void postorderTraversal(Node n) {
        if (n.left != null) {
            n.postorderTraversal(n.right);
        }
        System.out.println(n.data);
        if (n.right != null) {
            n.postorderTraversal(n.left);
        }
    }
}

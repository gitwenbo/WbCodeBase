package expressionParser.test1;

import java.util.ArrayList;

public class BinaryTree {
    Node root = null;

    public void creattree() {
        ArrayList<Node> elements = new ArrayList<Node>();
        ArrayList<Node> operators = new ArrayList<Node>();
        elements.add(new Node("1"));
        elements.add(new Node("2"));
        elements.add(new Node("6"));
        elements.add(new Node("8"));
        operators.add(new Node("+"));
        operators.add(new Node("+"));
        operators.add(new Node("-"));
        while (operators.size() > 0) {//当存储符号的数组队列大于零时，循环继续，注意：符号数要比数字数少一
            Node num1 = elements.remove(0);//将存放数字的数组队列的第一个数字移除并把它赋值给num1
            Node num2 = elements.remove(0);//然后再将存放数字的数组队列的第一个数字移除并把它赋值给num2
            Node s = operators.remove(0);//将存放符号的数组队列的第一个符号移除并把它赋值给s
            s.left = num1;//将结点对象num1赋值给s的左结点
            s.right = num2;//将结点对象num2赋值给s的左结点
            elements.add(0, s);//将符号结点s加入存放数字结点的第一位
        }
        root = elements.get(0);//将最后一个结点赋值给根节点
        Node n = new Node();//创建一个新的节点对象
        n.preorderTraversal(root);//调用前序遍历的方法
        n.inorderTraversal(root);//调用中序遍历的方法
        n.postorderTraversal(root);//调用后序遍历的方法
    }

    public static void main(String[] args) {
        BinaryTree two = new BinaryTree();//创建类的对象
        two.creattree();//执行创建二叉树的方法
    }
}


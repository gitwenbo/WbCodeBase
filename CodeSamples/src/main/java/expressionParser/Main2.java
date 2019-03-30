package expressionParser;

import java.util.Scanner;
import java.util.Stack;

class Node{
    char val;
    Node left;
    Node right;
    public Node(char val){
        this.val=val;
    }
}
public class Main2 {
    public static Node buildTree(String str){
        Stack<Node> stack=new Stack<Node>();
        for(char c:str.toCharArray()){
            if(c=='+'||c=='-'||c=='*'||c=='/'){
                Node node=new Node(c);
                Node right=stack.pop();
                Node left=stack.pop();
                node.left=left;
                node.right=right;
                stack.push(node);
            }else{
                Node node=new Node(c);
                stack.push(node);
            }
        }
        Node root=stack.pop();
        return root;
    }
    public static void preOrder(Node node){
        if(node==null)
            return;
        System.out.print(node.val);
        preOrder(node.left);
        preOrder(node.right);
    }
    public static void inOrder(Node node){
        if(node==null)
            return;
        inOrder(node.left);
        System.out.print(node.val);
        inOrder(node.right);
    }
    public static void main(String[] args){
        Scanner scanner = new Scanner(System.in);
        while(scanner.hasNext()){
            String str=scanner.nextLine();
            Node root=buildTree(str);
            preOrder(root);
            System.out.println();
            inOrder(root);
            System.out.println();
        }
        scanner.close();
    }
}

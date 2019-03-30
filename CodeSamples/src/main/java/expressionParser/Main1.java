package expressionParser;

import java.util.Scanner;

class Node1 {
    char val;
    Node1 left;
    Node1 right;

    public Node1(char val) {
        this.val = val;
    }
}

public class Main1 {
    public static Node1 buildTree(String str) {
        Node1 node1 = null;
        if (str.length() == 1) {
            node1 = new Node1(str.charAt(0));
            return node1;
        }
        int p = 0, c1 = -1, c2 = -1;            //p,c1,c2分别存放未匹配的括号数量，最右出现的+-号下标，最右出现的*/号下标
        for (int i = 0; i < str.length(); i++) {
            switch (str.charAt(i)) {
                case '(':
                    p++;
                    break;
                case ')':
                    p--;
                    break;
                case '+':
                case '-':
                    if (p == 0)
                        c1 = i;
                    break;
                case '*':
                case '/':
                    if (p == 0)
                        c2 = i;
                    break;
            }
        }
        if (c1 < 0 && c2 < 0)            //整个表达式是被一对括号括起来的
            node1 = buildTree(str.substring(1, str.length() - 1));
        else if (c1 > 0) {
            node1 = new Node1(str.charAt(c1));
            node1.left = buildTree(str.substring(0, c1));
            node1.right = buildTree(str.substring(c1 + 1, str.length()));
        } else {
            node1 = new Node1(str.charAt(c2));
            node1.left = buildTree(str.substring(0, c2));
            node1.right = buildTree(str.substring(c2 + 1, str.length()));
        }
        return node1;
    }

    public static void postOrder(Node1 node1) {
        if (node1 == null)
            return;
        postOrder(node1.left);
        postOrder(node1.right);
        System.out.print(node1.val);
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNext()) {
            String str = scanner.nextLine();
            Node1 root = buildTree(str);
            postOrder(root);
            System.out.println();
        }
        scanner.close();
    }
}

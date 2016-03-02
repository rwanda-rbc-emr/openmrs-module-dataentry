package test;

import java.util.ArrayList;
import java.util.List;

public class Test {
	public static void main(String[] args) {
		List<String> inList = new ArrayList<String>();
		List<List<String>> intList = new ArrayList<List<String>>();
		String b = "";
		int count = 0;
		for(int i = 0; i < 2; i++) {
			for(int j = 0; j < 3; j++) {
				b = j+"-"+i+"-"+count;
				inList.add(b);
				count++;
			}
			intList.add(inList);			
		}
		
		for(int k = 0; k < intList.size(); k++) {
			for(int x = 0; x < intList.get(k).size(); x++) {
				System.out.println("Size: "+intList.get(k).size());
				System.out.println(intList.get(k).get(x));
			}

			System.out.println("---------------");
		}
//		System.out.println("Fin du premier List");
//		for(List<String> lInt : intList) {
//			for(String in : inList) {
//				System.out.println(in);
//			}
//		}
		
	}
}

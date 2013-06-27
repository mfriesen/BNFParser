//
//  BNFStateDefinitionFactory.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-23.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFStateDefinitionFactory.h"

@implementation BNFStateDefinitionFactory

- (NSMutableDictionary *)json {
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    return dic;
}

/*
 @Override
 public Map<String, BNFStateDefinition> json() {
 
 Map<String, BNFStateDefinition> map = new HashMap<String, BNFStateDefinition>();
 
 Map<String, String> prop = loadProperties();
 
 for (Map.Entry<String, String> e : prop.entrySet()) {
 String name = e.getKey().toString();
 
 String value = e.getValue().toString();
 
 String[] values = value.split("[|]");
 
 List<BNFState> states = createStates(name, values);
 sort(states);
 
 map.put(name, new BNFStateDefinition(name, states));
 }
 
 return map;
 }
 
 private void sort(List<BNFState> states) {
 Collections.sort(states, new Comparator<BNFState>() {
 @Override
 public int compare(BNFState o1, BNFState o2) {
 if (o1.getClass().equals(BNFStateEmpty.class)) {
 return 1;
 } else if (o2.getClass().equals(BNFStateEmpty.class)) {
 return -1;
 }
 return 0;
 }
 });
 }
 
 private Map<String, String> loadProperties() {
 PropertyParser parser = new PropertyParser();
 InputStream is = getClass().getResourceAsStream("/ca/gobits/bnf/parser/json.bnf");
 try {
 return parser.parse(is);
 } catch (Exception e) {
 throw new RuntimeException(e);
 }
 }
 
 private List<BNFState> createStates(String name, String[] states)
 {
 List<BNFState> c = new ArrayList<BNFState>(states.length);
 
 for (String s : states) {
 
 BNFState firstState = null;
 BNFState previousState = null;
 String[] split = s.trim().split(" ");
 
 for (String ss : split) {
 
 BNFState state = createState(ss);
 
 if (firstState == null) {
 firstState = state;
 }
 
 if (previousState != null) {
 previousState.setNextState(state);
 }
 
 previousState = state;
 }
 
 if (previousState != null && name.equals("@start")) {
 previousState.setNextState(new BNFStateEnd());
 }
 
 c.add(firstState);
 }
 
 return c;
 }
 
 private BNFState createState(String ss) {
 boolean isTerminal = isTerminal(ss);
 String name = fixQuotedString(ss);
 BNFRepetition repetition = BNFRepetition.NONE;
 
 if (name.endsWith("*")) {
 repetition = BNFRepetition.ZERO_OR_MORE;
 name = name.substring(0, name.length() - 1);
 }
 
 BNFState state = createStateInstance(name, isTerminal);
 state.setName(name);
 state.setRepetition(repetition);
 
 return state;
 }
 
 private BNFState createStateInstance(String ss, boolean terminal) {
 BNFState state = null;
 
 if (terminal) {
 state = new BNFStateTerminal();
 } else if (ss.equals("Number")) {
 state = new BNFStateNumber();
 } else if (ss.equals("QuotedString")) {
 state = new BNFStateQuotedString();
 } else if (ss.equals("Empty")) {
 state = new BNFStateEmpty();
 } else {
 state = new BNFState();
 }
 
 return state;
 }
 
 private boolean isTerminal(String ss) {
 return ss.startsWith("'") || ss.startsWith("\"");
 }
 
 private String fixQuotedString(String ss) {
 
 int len = ss.length();
 int start = ss.startsWith("'") ? 1 : 0;
 int end = ss.endsWith(";") ? len - 1 : len;
 end = ss.endsWith("';") ? len - 2 : end;
 
 if (start > 0 || end < len) {
 ss = ss.substring(start, end);
 }
 
 return ss;
 }
 */
@end

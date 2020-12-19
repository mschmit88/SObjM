public class SObjM {

    /**
    * valueOf - will always match new version of sObject
    * 
    * Example:
    *
    * SObjM.val(...).equals(...).matches(sObj) => sObj will be used
    * SObjM.val(...).equals(...).matches(sObj, sObjOld) => sObj will be used
    */
    public static BeforeAfterFunc val(SObjectField field) {
        checkField(field);
        return new BeforeAfterFunc(field);
    }

    /**
    * priorValueOf - will match old version of sObject if present, otherwise new version
    * 
    * Example:
    *
    * SObjM.priorVal(...).equals(...).matches(sObj) => sObj will be used
    * SObjM.priorVal(...).equals(...).matches(sObj, sObjOld) => sObjOld will be used
    */
    public static Func priorVal(SObjectField field) {
        checkField(field);
        return new Func(field, true);
    }

    /**
    * and_x - groups matchers by and-operation
    * up to 5 matchers can be grouped without the need to create a list of matchers
    * 
    * Example:
    *
    * SObjM.and_x(
    *	SObjM.val(...).equals(...),
    * 	SObjM.val(...).equals(...),
    * )
    */

    public static MatcherGroup and_x(Set<SObjM.Matcher> matchers) {
        return new MatchAnd(matchers);
    }

    public static MatcherGroup and_x(SObjM.Matcher m1, SObjM.Matcher m2, SObjM.Matcher m3, SObjM.Matcher m4, SObjM.Matcher m5) {
        Set<SObjM.Matcher> matchers = new Set<SObjM.Matcher>{ m1, m2, m3, m4, m5 };
        matchers.remove(null);
        return new MatchAnd(matchers);
    }

    public static MatcherGroup and_x(SObjM.Matcher m1, SObjM.Matcher m2, SObjM.Matcher m3, SObjM.Matcher m4) {
        Set<SObjM.Matcher> matchers = new Set<SObjM.Matcher>{ m1, m2, m3, m4 };
        matchers.remove(null);
        return new MatchAnd(matchers);
    }

    public static MatcherGroup and_x(SObjM.Matcher m1, SObjM.Matcher m2, SObjM.Matcher m3) {
        Set<SObjM.Matcher> matchers = new Set<SObjM.Matcher>{ m1, m2, m3 };
        matchers.remove(null);
        return new MatchAnd(matchers);
    }

    public static MatcherGroup and_x(SObjM.Matcher m1, SObjM.Matcher m2) {
        Set<SObjM.Matcher> matchers = new Set<SObjM.Matcher>{ m1, m2 };
        matchers.remove(null);
        return new MatchAnd(matchers);
    }

    /**
    * or_x - groups matchers by or-operation
    * up to 5 matchers can be grouped without the need to create a list of matchers
    * 
    * Example:
    *
    * SObjM.or_x(
    *	SObjM.val(...).equals(...),
    * 	SObjM.val(...).equals(...),
    * )
    */

    public static MatcherGroup or_x(Set<SObjM.Matcher> matchers) {
        return new MatchOr(matchers);
    }
    
    public static MatcherGroup or_x(SObjM.Matcher m1, SObjM.Matcher m2, SObjM.Matcher m3, SObjM.Matcher m4, SObjM.Matcher m5) {
        Set<SObjM.Matcher> matchers = new Set<SObjM.Matcher>{ m1, m2, m3, m4, m5 };
        matchers.remove(null);
        return new MatchOr(matchers);
    }

    public static MatcherGroup or_x(SObjM.Matcher m1, SObjM.Matcher m2, SObjM.Matcher m3, SObjM.Matcher m4) {
        Set<SObjM.Matcher> matchers = new Set<SObjM.Matcher>{ m1, m2, m3, m4 };
        matchers.remove(null);
        return new MatchOr(matchers);
    }

    public static MatcherGroup or_x(SObjM.Matcher m1, SObjM.Matcher m2, SObjM.Matcher m3) {
        Set<SObjM.Matcher> matchers = new Set<SObjM.Matcher>{ m1, m2, m3 };
        matchers.remove(null);
        return new MatchOr(matchers);
    }

    public static MatcherGroup or_x(SObjM.Matcher m1, SObjM.Matcher m2) {
        Set<SObjM.Matcher> matchers = new Set<SObjM.Matcher>{ m1, m2 };
        matchers.remove(null);
        return new MatchOr(matchers);
    }
    
    /**
    * not_x - negates matcher
    * 
    * Example:
    *
    * SObjM.not_x( SObjM.val(...).equals(...) )
    */

    public static Matcher not_x(SObjM.Matcher matcher) {
        return new Negation(matcher);
    }

    /**
    * Func - inits all matchers that do not necessarily need the old version of the sObject
    * priorValueOf can only init matchers provided by this class
    */	

    public virtual class Func {
        protected final SObjectField field;
        protected final Boolean isPriorValue;

        protected Func(SObjectField field, Boolean isPriorValue) {
            this.field = field;
            this.isPriorValue = isPriorValue;
        }

        public SObjM.Matcher regex(String regexStr) {
            return new Regex(this.field, this.isPriorValue, regexStr);
        }

        public SObjM.Matcher equals(Object expectedValue) {
            return new Equals(this.field, this.isPriorValue, expectedValue);
        }

        public SObjM.Matcher notEquals(Object expectedValue) {
            return SObjM.not_x(new Equals(this.field, this.isPriorValue, expectedValue));
        }

        public SObjM.Matcher equalsIgnoreCase(String expectedValue) {
            return new EqualsIgnoreCase(this.field, this.isPriorValue, expectedValue);
        }

        public SObjM.Matcher notEqualsIgnoreCase(String expectedValue) {
            return SObjM.not_x(new EqualsIgnoreCase(this.field, this.isPriorValue, expectedValue));
        }

        public SObjM.Matcher length(Integer len) {
            return new Length(this.field, this.isPriorValue, len);
        }
        
        public SObjM.Matcher minLength(Integer minLen) {
            return new MinLength(this.field, this.isPriorValue, minLen);
        }

        public SObjM.Matcher maxLength(Integer maxLen) {
            return new MaxLength(this.field, this.isPriorValue, maxLen);
        }

        public SObjM.Matcher lengthBetween(Integer minLen, Integer maxLen) {
            return new LengthBetween(this.field, this.isPriorValue, minLen, maxLen);
        }

        public SObjM.Matcher contains(String substring) {
            return new Contains(this.field, this.isPriorValue, substring);
        }

        public SObjM.Matcher notContains(String substring) {
            return SObjM.not_x(new Contains(this.field, this.isPriorValue, substring));
        }
        
        public SObjM.Matcher containsIgnoreCase(String substring) {
            return new ContainsIgnoreCase(this.field, this.isPriorValue, substring);
        }

        public SObjM.Matcher notContainsIgnoreCase(String substring) {
            return SObjM.not_x(new ContainsIgnoreCase(this.field, this.isPriorValue, substring));
        }

        public SObjM.Matcher nil() {
            return new Nil(this.field, this.isPriorValue);
        }

        public SObjM.Matcher notNil() {
            return SObjM.not_x(new Nil(this.field, this.isPriorValue));
        }
        
        public SObjM.Matcher empty() {
            return new Empty(this.field, this.isPriorValue);
        }
        
        public SObjM.Matcher notEmpty() {
            return SObjM.not_x(new Empty(this.field, this.isPriorValue));
        }
        
        public SObjM.Matcher blank() {
            return new Blank(this.field, this.isPriorValue);
        }
        
        public SObjM.Matcher notBlank() {
            return SObjM.not_x(new Blank(this.field, this.isPriorValue));
        }

        public SObjM.Matcher equals(List<Object> expectedValues) {
            return new EqualsAny(this.field, this.isPriorValue, expectedValues);
        }

        public SObjM.Matcher equalsIgnoreCase(List<String> expectedValues) {
            return new EqualsAnyIgnoreCase(this.field, this.isPriorValue, expectedValues);
        }
        
        public SObjM.Matcher equalsNone(List<Object> expectedValues) {
            return new EqualsNone(this.field, this.isPriorValue, expectedValues);
        }
        
        public SObjM.Matcher equalsNoneIgnoreCase(List<String> expectedValues) {
            return new EqualsNoneIgnoreCase(this.field, this.isPriorValue, expectedValues);
        }
        
        public SObjM.Matcher startsWith(String prefix) {
            return new StartsWith(this.field, this.isPriorValue, prefix);
        }

        public SObjM.Matcher startsWithIgnoreCase(String prefix) {
            return new StartsWithIgnoreCase(this.field, this.isPriorValue, prefix);
        }

        public SObjM.Matcher endsWith(String suffix) {
            return new EndsWith(this.field, this.isPriorValue, suffix);
        }

        public SObjM.Matcher endsWithIgnoreCase(String suffix) {
            return new EndsWithIgnoreCase(this.field, this.isPriorValue, suffix);
        }

        public SObjM.Matcher greater(Object limitValue) {
            return new NumericComparator(   this.field, 
                                            this.isPriorValue, 
                                            limitValue, 
                                            NumericComparatorType.GT);
        }

        public SObjM.Matcher less(Object limitValue) {
            return new NumericComparator(   this.field, 
                                            this.isPriorValue, 
                                            limitValue, 
                                            NumericComparatorType.LT);
        }

        public SObjM.Matcher greaterEquals(Object limitValue) {
            return new NumericComparator(   this.field, 
                                            this.isPriorValue, 
                                            limitValue, 
                                            NumericComparatorType.GTE);
        }

        public SObjM.Matcher lessEquals(Object limitValue) {
            return new NumericComparator(   this.field, 
                                            this.isPriorValue, 
                                            limitValue, 
                                            NumericComparatorType.LTE);
        }

        public SObjM.Matcher betweenIncl(Object rightHandValue, Object leftHandValue) {
            return new NumericComparator(   this.field, 
                                            this.isPriorValue, 
                                            rightHandValue, 
                                            leftHandValue, 
                                            NumericComparatorType.BETWEEN_INCL);
        }

        public SObjM.Matcher betweenExcl(Object rightHandValue, Object leftHandValue) {
            return new NumericComparator(   this.field, 
                                            this.isPriorValue, 
                                            rightHandValue, 
                                            leftHandValue, 
                                            NumericComparatorType.BETWEEN_EXCL);
        }
        
        public SObjM.Matcher outsideIncl(Object rightHandValue, Object leftHandValue) {
            return new NumericComparator(   this.field, 
                                            this.isPriorValue, 
                                            rightHandValue, 
                                            leftHandValue, 
                                            NumericComparatorType.OUTSIDE_INCL);
        }

        public SObjM.Matcher outsideExcl(Object rightHandValue, Object leftHandValue) {
            return new NumericComparator(   this.field, 
                                            this.isPriorValue, 
                                            rightHandValue, 
                                            leftHandValue, 
                                            NumericComparatorType.OUTSIDE_EXCL);
        }

        public SObjM.Matcher must(SObjM.Matcher matcher) {
            return matcher.setField(this.field);
        }
        
        public SObjM.Matcher mustNot(SObjM.Matcher matcher) {
            return SObjM.not_x(matcher.setField(this.field));
        }
    }

    /**
    * BeforeAfterFunc - inits all matchers that do need the old version of the sObject
    * only valueOf is able to init matchers provided by this class
    */		
    
    public virtual class BeforeAfterFunc extends Func {
        public BeforeAfterFunc(SObjectField field) {
            super(field, false);
        }

        public SObjM.Matcher changed() {
            return new Changed(this.field);
        }

        public SObjM.Matcher changedFrom(Object oldValue) {
            return new ChangedFrom(this.field, oldValue);
        }

        public SObjM.Matcher changedFrom(List<Object> oldValues) {
            return new ChangedFromAny(this.field, oldValues);
        }

        public SObjM.Matcher changedTo(Object newValue) {
            return new ChangedTo(this.field, newValue);
        }

        public SObjM.Matcher changedTo(List<Object> newValues) {
            return new ChangedToAny(this.field, newValues);
        }

        public SObjM.Matcher changedFromTo(Object oldValue, Object newValue) {
            return new ChangedFromTo(this.field, oldValue, newValue);
        }

        public SObjM.Matcher changedFromTo(List<Object> oldValues, Object newValue) {
            return new ChangedFromAnyTo(this.field, oldValues, newValue);
        }

        public SObjM.Matcher changedFromTo(Object oldValue, List<Object> newValues) {
            return new ChangedFromToAny(this.field, oldValue, newValues);
        }

        public SObjM.Matcher changedFromTo(List<Object> oldValues, List<Object> newValues) {
            return new ChangedFromAnyToAny(this.field, oldValues, newValues);
        }
    }

    /**
    * Regex matcher implementation
    */

    private class Regex extends SObjM.Matcher {
        private final String regexStr;

        private Regex(SObjectField field, Boolean isPriorValue, String regexStr) {
            super(field, isPriorValue);
            this.regexStr = regexStr;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return Pattern.matches(this.regexStr, (String) sObj.get(this.field));
        }
    }

    /**
    * EqualsAny matcher implementation
    */

    private class EqualsAny extends SObjM.Matcher {
        private final Set<Object> expectedValues;

        private EqualsAny(SObjectField field, Boolean isPriorValue, List<Object> expectedValues) {
            super(field, isPriorValue);
            this.expectedValues = new Set<Object>(expectedValues);
        }

        protected override Boolean matchesImpl(SObject sObj) {
            Boolean isMatch = false;

            for(Object expectedValue : this.expectedValues) {
                if(expectedValue instanceof String) {
                    if(SObjM.stringEquals((String) expectedValue, (String) sObj.get(this.field))) {
                        isMatch = true;
                        break;
                    }
                }
                else if(expectedValue == sObj.get(this.field)) {
                    isMatch = true;
                    break;
                }
            }
            
            return isMatch;
        }
    }

    /**
    * EqualsAnyIgnoreCase matcher implementation
    */

    private class EqualsAnyIgnoreCase extends SObjM.Matcher {
        private final Set<String> expectedValues;

        private EqualsAnyIgnoreCase(SObjectField field, Boolean isPriorValue, List<String> expectedValues) {
            super(field, isPriorValue);
            this.expectedValues = new Set<String>(expectedValues);
        }

        protected override Boolean matchesImpl(SObject sObj) {
            Boolean isMatch = false;

            for(String expectedValue : this.expectedValues) {
                if(SObjM.stringEqualsIgnoreCase(expectedValue, (String) sObj.get(this.field))) {
                    isMatch = true;
                    break;
                }
            }

            return isMatch;
        }
    }

    /**
    * EqualsNone matcher implementation
    */
    
    private class EqualsNone extends SObjM.Matcher {
        private final Set<Object> expectedValues;

        private EqualsNone(SObjectField field, Boolean isPriorValue, List<Object> expectedValues) {
            super(field, isPriorValue);
            this.expectedValues = new Set<Object>(expectedValues);
        }

        protected override Boolean matchesImpl(SObject sObj) {
            Boolean isMatch = true;

            for(Object expectedValue : this.expectedValues) {
                if(expectedValue instanceof String) {
                    if(SObjM.stringEquals((String) expectedValue, (String) sObj.get(this.field))) {
                        isMatch = false;
                        break;
                    }
                }
                else if(expectedValue == sObj.get(this.field)) {
                    isMatch = false;
                    break;
                }
            }
            
            return isMatch;
        }
    }
    
    /**
    * EqualsNoneIgnoreCase matcher implementation
    */

    private class EqualsNoneIgnoreCase extends SObjM.Matcher {
        private final Set<String> expectedValues;

        private EqualsNoneIgnoreCase(SObjectField field, Boolean isPriorValue, List<String> expectedValues) {
            super(field, isPriorValue);
            this.expectedValues = new Set<String>(expectedValues);
        }

        protected override Boolean matchesImpl(SObject sObj) {
            Boolean isMatch = true;

            for(String expectedValue : this.expectedValues) {
                if(SObjM.stringEqualsIgnoreCase(expectedValue, (String) sObj.get(this.field))) {
                    isMatch = false;
                    break;
                }
            }
            
            return isMatch;
        }
    }

    /**
    * StartsWith matcher implementation
    */
    
    private class StartsWith extends SObjM.Matcher {
        private final String prefix;

        private StartsWith(SObjectField field, Boolean isPriorValue, String prefix) {
            super(field, isPriorValue);
            this.prefix = prefix;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return SObjM.stringStartsWith((String) sObj.get(this.field), this.prefix);
        }
    }

    /**
    * StartsWithIgnoreCase matcher implementation
    */
    
    private class StartsWithIgnoreCase extends SObjM.Matcher {
        private final String prefix;

        private StartsWithIgnoreCase(SObjectField field, Boolean isPriorValue, String prefix) {
            super(field, isPriorValue);
            this.prefix = prefix;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return SObjM.stringStartsWithIgnoreCase((String) sObj.get(this.field), this.prefix);
        }
    }

    /**
    * EndsWith matcher implementation
    */
    
    private class EndsWith extends SObjM.Matcher {
        private final String suffix;

        private EndsWith(SObjectField field, Boolean isPriorValue, String suffix) {
            super(field, isPriorValue);
            this.suffix = suffix;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return SObjM.stringEndsWith((String) sObj.get(this.field), this.suffix);
        }
    }

    /**
    * EndsWithIgnoreCase matcher implementation
    */
    
    private class EndsWithIgnoreCase extends SObjM.Matcher {
        private final String suffix;

        private EndsWithIgnoreCase(SObjectField field, Boolean isPriorValue, String suffix) {
            super(field, isPriorValue);
            this.suffix = suffix;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return SObjM.stringEndsWithIgnoreCase((String) sObj.get(this.field), this.suffix);
        }
    }

    /**
    * Negation matcher implementation
    */

    private class Negation extends SObjM.Matcher {
        private final SObjM.Matcher negatedMatcher;

        private Negation(SObjM.Matcher negatedMatcher) {
            this.negatedMatcher = negatedMatcher;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return ! this.negatedMatcher.matches(sObj);
        }
    }

    /**
    * Equals matcher implementation
    */

    private class Equals extends SObjM.Matcher {
        private final Object expectedValue;

        private Equals(SObjectField field, Boolean isPriorValue, Object expectedValue) {
            super(field, isPriorValue);
            this.expectedValue = expectedValue;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            if(this.expectedValue instanceof String) {
                return SObjM.stringEquals((String) this.expectedValue, (String) sObj.get(this.field));
            }

            return sObj.get(this.field) == this.expectedValue;
        }
    }

    /**
    * EqualsIgnoreCase matcher implementation
    */
    
    private class EqualsIgnoreCase extends SObjM.Matcher {
        private final String expectedValue;

        private EqualsIgnoreCase(SObjectField field, Boolean isPriorValue, String expectedValue) {
            super(field, isPriorValue);
            this.expectedValue = expectedValue;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return SObjM.stringEqualsIgnoreCase(expectedValue, (String) sObj.get(this.field));
        }
    }

    /**
    * Contains matcher implementation
    */

    private class Contains extends SObjM.Matcher {
        private final String substring;

        private Contains(SObjectField field, Boolean isPriorValue, String substring) {
            super(field, isPriorValue);
            this.substring = substring;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return SObjM.stringContains((String) sObj.get(this.field), this.substring);
        }
    }

    /**
    * ContainsIgnoreCase matcher implementation
    */
    
    private class ContainsIgnoreCase extends SObjM.Matcher {
        private final String substring;

        private ContainsIgnoreCase(SObjectField field, Boolean isPriorValue, String substring) {
            super(field, isPriorValue);
            this.substring = substring;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return SObjM.stringContainsIgnoreCase((String) sObj.get(this.field), this.substring);
        }
    }

    /**
    * Nil matcher implementation
    */

    private class Nil extends SObjM.Matcher {
        private Nil(SObjectField field, Boolean isPriorValue) {
            super(field, isPriorValue);
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return sObj.get(this.field) == null;
        }
    }

    /**
    * Length matcher implementation
    */
    
    private class Length extends SObjM.Matcher {
        private Integer len;

        private Length(SObjectField field, Boolean isPriorValue, Integer len) {
            super(field, isPriorValue);

            if(len == null) {
                throw new SObjMException('len cannot be null');
            }

            this.len = len;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            String value = (String) sObj.get(this.field);

            if(value == null) {
                return false;
            }

            return value.length() == this.len;
        }
    }

    /**
    * MinLength matcher implementation
    */

    private class MinLength extends SObjM.Matcher {
        private Integer minLen;

        private MinLength(SObjectField field, Boolean isPriorValue, Integer minLen) {
            super(field, isPriorValue);

            if(minLen == null) {
                throw new SObjMException('minLen cannot be null');
            }

            this.minLen = minLen;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            String value = (String) sObj.get(this.field);

            if(value == null) {
                return false;
            }

            return value.length() >= this.minLen;
        }
    }

    /**
    * MaxLength matcher implementation
    */

    private class MaxLength extends SObjM.Matcher {
        private Integer maxLen;

        private MaxLength(SObjectField field, Boolean isPriorValue, Integer maxLen) {
            super(field, isPriorValue);

            if(maxLen == null) {
                throw new SObjMException('maxLen cannot be null');
            }

            this.maxLen = maxLen;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            String value = (String) sObj.get(this.field);

            if(value == null) {
                return false;
            }

            return value.length() <= this.maxLen;
        }
    }

    /**
    * LengthBetween matcher implementation
    */

    private class LengthBetween extends SObjM.Matcher {
        private Integer minLen;
        private Integer maxLen;

        private LengthBetween(SObjectField field, Boolean isPriorValue, Integer minLen, Integer maxLen) {
            super(field, isPriorValue);

            if(minLen == null || maxLen == null) {
                throw new SObjMException('minLen/maxLen cannot be null');
            }

            this.minLen = minLen;
            this.maxLen = maxLen;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            String value = (String) sObj.get(this.field);

            if(value == null) {
                return false;
            }
            
            return value.length() >= this.minLen && value.length() <= this.maxLen;
        }
    }

    /**
    * Empty matcher implementation
    */

    private class Empty extends SObjM.Matcher {
        private Empty(SObjectField field, Boolean isPriorValue) {
            super(field, isPriorValue);
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return String.isEmpty(((String) sObj.get(this.field)));
        }
    }

    /**
    * Blank matcher implementation
    */

    private class Blank extends SObjM.Matcher {
        private Blank(SObjectField field, Boolean isPriorValue) {
            super(field, isPriorValue);
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return String.isBlank(((String) sObj.get(this.field)));
        }
    }

    /**
    * Changed matcher implementation
    */

    private class Changed extends SObjM.Matcher {
        private Changed(SObjectField field) {
            super(field, false);
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return false;
        }

        protected override Boolean matchesImpl(SObject sObj, SObject sObjOld) {
            Object oldValue = sObjOld.get(this.field);
            Object newValue = sObj.get(this.field);
            Boolean isString = newValue instanceof String || oldValue instanceof String;
            
            if(isString) {
                return ! SObjM.stringEquals((String) newValue, (String) oldValue);
            }

            return oldValue != newValue;
        }
    }

    /**
    * ChangedFrom matcher implementation
    */

    private class ChangedFrom extends SObjM.Matcher {
        private Object fromValue;

        private ChangedFrom(SObjectField field, Object fromValue) {
            super(field, false);
            this.fromValue = fromValue;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return false;
        }

        protected override Boolean matchesImpl(SObject sObj, SObject sObjOld) {
            Object actualFromValue = sObjOld.get(this.field);
            Object actualToValue = sObj.get(this.field);
            Boolean isString = actualFromValue instanceof String || actualToValue instanceof String;

            if(isString) {
                return SObjM.stringEquals((String) actualFromValue, (String) this.fromValue) 
                    && ! SObjM.stringEquals((String) actualFromValue, (String) actualToValue);
            }

            return actualFromValue == this.fromValue && actualFromValue != actualToValue;
        }
    }

    /**
    * ChangedFromAny matcher implementation
    */

    private class ChangedFromAny extends SObjM.Matcher {
        private Set<Object> fromValues;

        private ChangedFromAny(SObjectField field, List<Object> fromValues) {
            super(field, false);
            this.fromValues = new Set<Object>(fromValues);
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return false;
        }

        protected override Boolean matchesImpl(SObject sObj, SObject sObjOld) {
            Object actualFromValue = sObjOld.get(this.field);
            Object actualToValue = sObj.get(this.field);
            Boolean isString = actualFromValue instanceof String || actualToValue instanceof String;
            Boolean objectChanged = ! isString && actualFromValue != actualToValue;
            Boolean stringChanged = isString && ! SObjM.stringEquals((String) actualFromValue, (String) actualToValue);

            if(! objectChanged && ! stringChanged) {
                return false;
            }

            Boolean isMatch = false;

            for(Object fromValue : this.fromValues) {
                Boolean objectEquals = ! isString && fromValue == actualFromValue;
                Boolean stringEquals = isString && stringEquals((String) fromValue, (String) actualfromValue);
                
                if(objectEquals || stringEquals) {
                    isMatch = true;
                    break;
                }
            }

            return isMatch;
        }
    }

    /**
    * ChangedTo matcher implementation
    */

    private class ChangedTo extends SObjM.Matcher {
        private Object toValue;

        private ChangedTo(SObjectField field, Object toValue) {
            super(field, false);
            this.toValue = toValue;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return false;
        }

        protected override Boolean matchesImpl(SObject sObj, SObject sObjOld) {
            Object oldValue = sObjOld.get(this.field);
            Object newValue = sObj.get(this.field);
            Boolean isString = newValue instanceof String || oldValue instanceof String;

            if(isString) {
                return SObjM.stringEquals((String) newValue, (String) this.toValue) 
                    && ! SObjM.stringEquals((String) oldValue, (String) newValue);
            }

            return newValue == this.toValue && oldValue != newValue;
        }
    }

    /**
    * ChangedToAny matcher implementation
    */

    private class ChangedToAny extends SObjM.Matcher {
        private Set<Object> toValues;

        private ChangedToAny(SObjectField field, List<Object> toValues) {
            super(field, false);
            this.toValues = new Set<Object>(toValues);
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return false;
        }

        protected override Boolean matchesImpl(SObject sObj, SObject sObjOld) {
            Object actualFromValue = sObjOld.get(this.field);
            Object actualToValue = sObj.get(this.field);
            Boolean isString = actualFromValue instanceof String || actualToValue instanceof String;
            Boolean objectChanged = ! isString && actualFromValue != actualToValue;
            Boolean stringChanged = isString && ! SObjM.stringEquals((String) actualFromValue, (String) actualToValue);

            if(! objectChanged && ! stringChanged) {
                return false;
            }

            Boolean isMatch = false;

            for(Object toValue : this.toValues) {
                Boolean objectEquals = ! isString && toValue == actualToValue;
                Boolean stringEquals = isString && stringEquals((String) toValue, (String) actualToValue);
                
                if(objectEquals || stringEquals) {
                    isMatch = true;
                    break;
                }
            }

            return isMatch;
        }
    }

    /**
    * ChangedFromTo matcher implementation
    */

    private class ChangedFromTo extends SObjM.Matcher {
        private Object fromValue;
        private Object toValue;

        private ChangedFromTo(SObjectField field, Object fromValue, Object toValue) {
            super(field, false);
            this.fromValue = fromValue;
            this.toValue = toValue;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return false;
        }

        protected override Boolean matchesImpl(SObject sObj, SObject sObjOld) {
            Object actualFromValue = sObjOld.get(this.field);
            Object actualToValue = sObj.get(this.field);
            Boolean isString = actualFromValue instanceof String || actualToValue instanceof String;

            if(isString) {
                return SObjM.stringEquals((String) fromValue, (String) actualFromValue) 
                        && SObjM.stringEquals((String) toValue, (String) actualToValue)
                        && ! SObjM.stringEquals((String) actualFromValue, (String) actualToValue);
            }

            return fromValue == actualFromValue 
                    && toValue == actualToValue 
                    && actualFromValue != actualToValue;
        }
    }

    /**
    * ChangedFromAnyTo matcher implementation
    */

    private class ChangedFromAnyTo extends SObjM.Matcher {
        private Set<Object> fromValues;
        private Object toValue;

        private ChangedFromAnyTo(SObjectField field, List<Object> fromValues, Object toValue) {
            super(field, false);
            this.fromValues = new Set<Object>(fromValues);
            this.toValue = toValue;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return false;
        }

        protected override Boolean matchesImpl(SObject sObj, SObject sObjOld) {
            Object actualFromValue = sObjOld.get(this.field);
            Object actualToValue = sObj.get(this.field);
            Boolean isString = actualFromValue instanceof String || actualToValue instanceof String;
            Boolean objectChanged = ! isString && actualFromValue != actualToValue;
            Boolean stringChanged = isString && ! SObjM.stringEquals((String) actualFromValue, (String) actualToValue);

            if(! objectChanged && ! stringChanged) {
                return false;
            }

            Boolean isFromMatch = false;

            for(Object fromValue : this.fromValues) {
                Boolean objectEquals = ! isString && fromValue == actualFromValue;
                Boolean stringEquals = isString && stringEquals((String) fromValue, (String) actualFromValue);

                if(objectEquals || stringEquals) {
                    isFromMatch = true;
                    break;
                }
            }

            Boolean isStringToMatch = isString && stringEquals((String) toValue, (String) actualToValue);
            Boolean isObjectToMatch = ! isString && toValue == actualToValue;
            
            return isFromMatch && (isStringToMatch || isObjectToMatch);
        }
    }

    /**
    * ChangedFromToAny matcher implementation
    */

    private class ChangedFromToAny extends SObjM.Matcher {
        private Object fromValue;
        private Set<Object> toValues;

        private ChangedFromToAny(SObjectField field, Object fromValue, List<Object> toValues) {
            super(field, false);
            this.fromValue = fromValue;
            this.toValues = new Set<Object>(toValues);
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return false;
        }

        protected override Boolean matchesImpl(SObject sObj, SObject sObjOld) {
            Object actualFromValue = sObjOld.get(this.field);
            Object actualToValue = sObj.get(this.field);
            Boolean isString = actualFromValue instanceof String || actualToValue instanceof String;
            Boolean objectChanged = ! isString && actualFromValue != actualToValue;
            Boolean stringChanged = isString && ! SObjM.stringEquals((String) actualFromValue, (String) actualToValue);

            if(! objectChanged && ! stringChanged) {
                return false;
            }

            Boolean isToMatch = false;

            for(Object toValue : this.toValues) {
                Boolean objectEquals = ! isString && toValue == actualToValue;
                Boolean stringEquals = isString && stringEquals((String) toValue, (String) actualToValue);

                if(objectEquals || stringEquals) {
                    isToMatch = true;
                    break;
                }
            }

            Boolean isStringFromMatch = isString && stringEquals((String) fromValue, (String) actualFromValue);
            Boolean isObjectFromMatch = ! isString && fromValue == actualFromValue;
            
            return isToMatch && (isStringFromMatch || isObjectFromMatch);
        }
    }

    /**
    * ChangedFromAnyToAny matcher implementation
    */

    private class ChangedFromAnyToAny extends SObjM.Matcher {
        private Set<Object> fromValues;
        private Set<Object> toValues;

        private ChangedFromAnyToAny(SObjectField field, List<Object> fromValues, List<Object> toValues) {
            super(field, false);
            this.fromValues = new Set<Object>(fromValues);
            this.toValues = new Set<Object>(toValues);
        }

        protected override Boolean matchesImpl(SObject sObj) {
            return false;
        }

        protected override Boolean matchesImpl(SObject sObj, SObject sObjOld) {
            Object actualFromValue = sObjOld.get(this.field);
            Object actualToValue = sObj.get(this.field);
            Boolean isString = actualFromValue instanceof String || actualToValue instanceof String;
            Boolean objectChanged = ! isString && actualFromValue != actualToValue;
            Boolean stringChanged = isString && ! SObjM.stringEquals((String) actualFromValue, (String) actualToValue);

            if(! objectChanged && ! stringChanged) {
                return false;
            }

            Boolean isFromMatch = false;

            for(Object fromValue : this.fromValues) {
                Boolean objectEquals = ! isString && fromValue == actualFromValue;
                Boolean stringEquals = isString && stringEquals((String) fromValue, (String) actualFromValue);

                if(objectEquals || stringEquals) {
                    isFromMatch = true;
                    break;
                }
            }

            Boolean isToMatch = false;

            for(Object toValue : this.toValues) {
                Boolean objectEquals = ! isString && toValue == actualToValue;
                Boolean stringEquals = isString && stringEquals((String) toValue, (String) actualToValue);

                if(objectEquals || stringEquals) {
                    isToMatch = true;
                    break;
                }
            }
            
            return isFromMatch && isToMatch;
        }
    }

    private enum NumericComparatorType { 
        GT, 
        LT, 
        GTE, 
        LTE, 
        BETWEEN_INCL, 
        BETWEEN_EXCL,
        OUTSIDE_INCL,
        OUTSIDE_EXCL 
    }

    /**
    * NumericComparator - implementation for all numeric matchers
    */

    private class NumericComparator extends SObjM.Matcher {
        private final Object value1;
        private final Object value2;
        private final NumericComparatorType type;

        private NumericComparator(  SObjectField field, 
                                    Boolean isPriorValue, 
                                    Object value1, 
                                    NumericComparatorType type) {
            super(field, isPriorValue);
            this.value1 = value1;
            this.type = type;
        }

        private NumericComparator(  SObjectField field, 
                                    Boolean isPriorValue, 
                                    Object value1, 
                                    Object value2, 
                                    NumericComparatorType type) {
            this(field, isPriorValue, value1, type);
            this.value2 = value2;
        }

        protected override Boolean matchesImpl(SObject sObj) {
            Boolean isMatch = false;
            Object value = sObj.get(field);
            Boolean isIntegerOrDecimal = value instanceof Integer || value instanceof Decimal;
            Boolean isDateOrDatetime = value instanceof Date || value instanceof Datetime;

            if(isIntegerOrDecimal) {
                Decimal decimalValue = (Decimal) value;
                Decimal decimalValue1 = (Decimal) value1;
                Decimal decimalValue2 = (Decimal) value2;

                switch on this.type {
                    when GT {
                        isMatch = decimalValue > decimalValue1;
                    }
                    when GTE {
                        isMatch = decimalValue >= decimalValue1;
                    }
                    when LT {
                        isMatch = decimalValue < decimalValue1;
                    }
                    when LTE {
                        isMatch = decimalValue <= decimalValue1;
                    }
                    when BETWEEN_INCL {
                        isMatch = decimalValue >= decimalValue1 && decimalValue <= decimalValue2;
                    }
                    when BETWEEN_EXCL {
                        isMatch = decimalValue > decimalValue1 && decimalValue < decimalValue2;
                    }
                    when OUTSIDE_INCL {
                        isMatch = decimalValue <= decimalValue1 || decimalValue >= decimalValue2;
                    }
                    when OUTSIDE_EXCL {
                        isMatch = decimalValue < decimalValue1 || decimalValue > decimalValue2;
                    }					
                }
            }
            else if(isDateOrDatetime) {
                Datetime datetimeValue = (Datetime) value;
                Datetime datetimeValue1 = (Datetime) value1;
                Datetime datetimeValue2 = (Datetime) value2;

                switch on this.type {
                    when GT {
                        isMatch = datetimeValue > datetimeValue1;
                    }
                    when GTE {
                        isMatch = datetimeValue >= datetimeValue1;
                    }
                    when LT {
                        isMatch = datetimeValue < datetimeValue1;
                    }
                    when LTE {
                        isMatch = datetimeValue <= datetimeValue1;
                    }
                    when BETWEEN_INCL {
                        isMatch = datetimeValue >= datetimeValue1 && datetimeValue <= datetimeValue2;
                    }
                    when BETWEEN_EXCL {
                        isMatch = datetimeValue > datetimeValue1 && datetimeValue < datetimeValue2;
                    }
                    when OUTSIDE_INCL {
                        isMatch = datetimeValue <= datetimeValue1 || datetimeValue >= datetimeValue2;
                    }
                    when OUTSIDE_EXCL {
                        isMatch = datetimeValue < datetimeValue1 || datetimeValue > datetimeValue2;
                    }
                }
            }

            return isMatch;
        }
    }

    /**
    * MatcherGroup - base class for all group matchers
    */

    public abstract class MatcherGroup extends Matcher {
        private final Set<SObjM.Matcher> matchers = new Set<SObjM.Matcher>();

        protected MatcherGroup(Set<SObjM.Matcher> matchers) {
            this.matchers.addAll(matchers);
        }
    }

    /**
    * MatchOr - or-operation implementation
    */

    public class MatchOr extends MatcherGroup {
        private MatchOr(Set<SObjM.Matcher> matchers) {
            super(matchers);
        }

        protected override Boolean matchesImpl(SObject sObj) {
            Boolean isMatch = false;

            for(SObjM.Matcher matcher : this.matchers) {
                if(matcher.matches(sObj)) {
                    isMatch = true;
                    break;
                }
            }

            return isMatch;
        }
        
        protected override Boolean matchesImpl(SObject sObj, SObject sObjOld) {
            Boolean isMatch = false;

            for(SObjM.Matcher matcher : this.matchers) {
                if(matcher.matches(sObj, sObjOld)) {
                    isMatch = true;
                    break;
                }				
            }

            return isMatch;
        }
    }

    /**
    * MatchAnd - and-operation implementation
    */

    public class MatchAnd extends MatcherGroup {
        private MatchAnd(Set<SObjM.Matcher> matchers) {
            super(matchers);
        }

        protected override Boolean matchesImpl(SObject sObj) {
            Boolean isMatch = true;

            for(SObjM.Matcher matcher : this.matchers) {
                if(! matcher.matches(sObj)) {
                    isMatch = false;
                    break;
                }
            }

            return isMatch;
        }
        
        protected override Boolean matchesImpl(SObject sObj, SObject sObjOld) {
            Boolean isMatch = true;

            for(SObjM.Matcher matcher : this.matchers) {
                if(! matcher.matches(sObj, sObjOld)) {
                    isMatch = false;
                    break;
                }
            }

            return isMatch;
        }
    }

    /**
    * Matcher - base class for all matchers
    */

    public abstract class Matcher {
        public SObjectField field { public get; private set; }
        protected Boolean isPriorValue = false;

        protected Matcher(SObjectField field, Boolean isPriorValue) {
            this.field = field;
            this.isPriorValue = isPriorValue;
        }

        protected Matcher() { }

        public Boolean matches(SObject sObj) {
            SObjM.checkSObj(sObj);
            return this.matchesImpl(sObj);
        }

        public Boolean matches(SObject sObj, SObject sObjOld) {
            SObjM.checkSObj(sObj);
            SObjM.checkSObj(sObjOld);
            return this.matchesImpl(sObj, sObjOld);
        }

        protected abstract Boolean matchesImpl(SObject sObj);

        protected virtual Boolean matchesImpl(SObject sObj, SObject sObjOld) {
            return this.isPriorValue ? this.matches(sObjOld) : this.matches(sObj);
        }
        
        public Result matches(List<SObject> sObjs) {
            List<SObject> hits = new List<SObject>();
            List<SObject> misses = new List<SObject>();

            for(SObject sObj : sObjs) {
                Boolean isMatch = this.matches(sObj);

                if(isMatch) {
                    hits.add(sObj);
                }
                else {
                    misses.add(sObj);
                }
            }

            return new Result(hits, misses);
        }

        public Result matches(List<SObject> sObjs, Map<Id, SObject> sObjById) {
            List<SObject> hits = new List<SObject>();
            List<SObject> misses = new List<SObject>();

            for(SObject sObj : sObjs) {
                Id sObjId = (Id) sObj.get('Id');

                if(sObjId == null) {
                    throw new SObjMException('sObject id cannot be null');
                }

                SObject sObjOld = sObjById.get(sObjId);
                Boolean isMatch = this.matches(sObj, sObjOld);

                if(isMatch) {
                    hits.add(sObj);
                }
                else {
                    misses.add(sObj);
                }
            }

            return new Result(hits, misses);
        }

        private SObjM.Matcher setField(SObjectField field) {
            this.field = field;
            return this;
        }
    }
    
    /**
    * Result - data class to return matche operations on sObject collection
    */

    public class Result {
        public final List<SObject> hits = new List<SObject>();
        public final List<SObject> misses = new List<SObject>();

        public Result(List<SObject> hits, List<SObject> misses) {
            this.hits.addAll(hits);
            this.misses.addAll(misses);
        }
    }

    /**
    * helper
    */

    @TestVisible
    private static Boolean stringEquals(String expected, String actual) {
        if(expected == null && actual == null) {
            return true;
        }

        if(expected == null || actual == null) {
            return false;
        }

        return expected.equals(actual);
    }

    @TestVisible
    private static Boolean stringEqualsIgnoreCase(String expected, String actual) {
        if(expected == null && actual == null) {
            return true;
        }

        if(expected == null || actual == null) {
            return false;
        }

        return expected.equalsIgnoreCase(actual);
    }

    @TestVisible
    private static Boolean stringContains(String str, String substr) {
        if(str == null || substr == null) {
            return false;
        }

        return str.contains(substr);
    }

    @TestVisible
    private static Boolean stringContainsIgnoreCase(String str, String substr) {
        if(str == null || substr == null) {
            return false;
        }

        return str.containsIgnoreCase(substr);
    }

    @TestVisible
    private static Boolean stringStartsWith(String str, String prefix) {
        if(str == null || prefix == null) {
            return false;
        }

        return str.startsWith(prefix);
    }

    @TestVisible
    private static Boolean stringStartsWithIgnoreCase(String str, String prefix) {
        if(str == null || prefix == null) {
            return false;
        }

        return str.startsWithIgnoreCase(prefix);
    }

    @TestVisible
    private static Boolean stringEndsWith(String str, String suffix) {
        if(str == null || suffix == null) {
            return false;
        }

        return str.endsWith(suffix);
    }

    @TestVisible
    private static Boolean stringEndsWithIgnoreCase(String str, String suffix) {
        if(str == null || suffix == null) {
            return false;
        }

        return str.endsWithIgnoreCase(suffix);
    }

    @TestVisible
    private static void checkField(SObjectField field) {
        if(field == null) {
            throw new SObjMException('field cannot be null');
        }
    }

    @TestVisible
    private static void checkSObj(SObject sObj) {
        if(sObj == null) {
            throw new SObjMException('sObj cannot be null');
        }
    }

    public class SObjMException extends Exception { }
}

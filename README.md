# SObjM (or SObject Matcher)

## Intention

Since I started working with Salesforce Apex, I disliked the fact that one must re-write (pretty much) the same boiler plate code to sort out some sObjects (mostly in triggers) to perform certain actions on them.

A filter requirement could look like this:

Accounts:

- having an annual revenue between 200k and 300k
- and of type "Partner"
- and billing country is Germany

So the code meet this requirement typically looks like this:

```java
List<Account> accs = // Trigger.new or wherever they came from
List<Account> accsFiltered = new List<Account>();

for(Account acc : accs) {
    if(
        acc.AnnualRevenue >= 200000 && acc.AnnualRevenue <= 300000
        && acc.Type == 'Partner'
        && acc.BillingCountry == 'Germany'
    ) {
        accsFiltered.add(acc);
    }
}

// perform further actions with accsFiltered
```

So spending a lot of time on writing for loops and produce code that is not easy to read does not seem to be a good idea.

Sure it can be made more readable by seperating the conditions into multiple booleans or putting some logic into util classes. But still, the use cases can be way more complex and over time the code turns more and more into spaghetti (especially if the code also needs to deal with old and new sObjects).

## Solution

I had been googling to find a project that solves this problem for some time but never really found a solution that had the functionalities I was looking for.

So being forced to stay at home during the COVID pandemic gave me some time to come up with a solution that fits my requirements.

The outcome is just one class that has zero dependencies and can be used in any org. New matchers can be implmented by extending the SObjM.Matcher class. Keep reading and further information ;)

The previous example using this class look like this:

```java
List<Account> accs = // Trigger.new or wherever they came from
List<Account> accsFiltered = (List<Account>) SObjM.and_x(
                                SObjM.valueOf(Account.AnnualRevenue).betweenIncl(200000, 300000),
                                SObjM.valueOf(Account.Type).equals('Partner'),
                                SObjM.valueOf(Account.BillingCountry).equals('Germany')
                            ).matches(accounts);
```

I will be more than happy for feedback and maybe even ideas for new functionalities that I have missed :)

## Documentation

### Installation

Just copy paste both classes SObjM and SObjM_T into your org and you are ready to go.

### Instantiating a matcher

There are 5 ways to instantiate a matcher:

#### valueOf()

Using this method, you can create a matcher who matches on an (new) sObject.

Example:

```java
SObjectM.Matcher matcher = SObjM.valueOf(Account.Name).equals('xzy');
```

#### priorValueOf()

Using this method, you can create a matcher who matches on an old sObject if present. If old sObject is not present, it will behave just like valueOf().

Example:

```java
SObjectM.Matcher matcher = SObjM.priorValueOf(Account.Name).equals('xzy');
```

#### not_x()

Using this method, you can create a matcher who negates the matcher that is passed into it.

Example:

```java
SObjectM.Matcher matcher = SObjM.not_x( SObjM.priorValueOf(Account.Name).equals('xzy') );
```

#### and_x()

Using this method, you can create a matcher who groups all passed matchers by an and-operation.

Example:

```java
SObjectM.Matcher matcher = SObjM.and_x(
                                SObjM.valueOf(Account.Name).equals('xzy'),
                                SObjM.valueOf(Account.Type).notEquals('abc'));
```

Up to 5 matchers can be passed without the need to create a list of matchers. Otherwise the code looks like this:

```java
SObjectM.Matcher matcher = SObjM.and_x(new Set<SObjM.Matcher> {
                                SObjM.valueOf(Account.Name).equals('xzy'),
                                SObjM.valueOf(Account.Type).notEquals('a')),
                                SObjM.valueOf(Account.Type).notEquals('b')),
                                SObjM.valueOf(Account.Type).notEquals('c')),
                                SObjM.valueOf(Account.Type).notEquals('d')),
                                SObjM.valueOf(Account.Type).notEquals('e'))
                            });

```

#### or_x()

Same as and_x but or_x ;)

### Using a matcher

As you have instantiated a matcher, you want to match one or multiple sObjects with it.

To do so, you have four methods.

#### Boolean matches(SObject)

If you need to check if <b>one</b> sObject meets certain criterias, then use this method.

Example:

```java
SObjectM.Matcher someMeaningfulNameMatcher = SObjM.valueOf(Account.Name).equals('xyz');

if(someMeaningfulNameMatcher.matches(someAccount)) {
    // it matches!
}
```

#### Boolean matches(SObject, SObject)

If you need to check if <b>one</b> sObject meets certain criterias and also need to check the <b>old version</b> of the sObject, then use this method.

Example:

```java
SObjectM.Matcher accountNameChangedFromNewToOld = SObjM.and_x(
                                                    SObjM.valueOf(Account.Name).equals('new'),
                                                    SObjM.priorValueOf(Account.Name).equals('old'));

if(accountNameChangedFromNewToOld.matches(newAccount, oldAccount)) {
    // it matches!
}
```

#### SObjM.Result matches(List<SObject>)

If you need to check if <b>multiple</b> sObjects meet certain criterias, then use this method.

Example:

```java
SObjM.Matcher someMeaningfulNameMatcher = SObjM.valueOf(Account.Name).equals('xyz');
SObjM.Result res = someMeaningfulNameMatcher.matches(accounts);

List<Account> matchingAccounts = (List<Account>) res.hits;
List<Account> nonMatchingAccounts = (List<Account>) res.misses;
```

#### Boolean matches(List<SObject>, Map<Id, Sobject>)

If you need to check if <b>multiple</b> sObjects meet certain criterias and you also need to check the <b>old version</b> of the sObject, then use this method.

Example:

```java
SObjectM.Matcher accountNameChangedFromNewToOld = SObjM.and_x(
                                                    SObjM.valueOf(Account.Name).equals('new'),
                                                    SObjM.priorValueOf(Account.Name).equals('old'));

SObjM.Result res = someMeaningfulNameMatcher.matches(newAccounts, oldAccountsById);

List<Account> matchingAccounts = (List<Account>) res.hits;
List<Account> nonMatchingAccounts = (List<Account>) res.misses;
```

### Creating a custom matcher

If the built-in matchers do not meet your requirement, then you can easily create a custom matcher by extending the SObjM.Matcher class.

Example:

```java
public class BeFirstDayOfMonth extends SObjM.Matcher {
    public BeFirstDayOfMonth() {
        super();
    }

    protected Boolean matchesImpl(SObject sObj) {
        Date dateValue = (Date) sObj.get(this.field);

        if(dateValue == null) {
            return false;
        }

        return dateValue.day() == 1;
    }
}
```

You can then use the custom matcher by passing an instance of it into the methods must() / mustNot()

```java
SObjM.Matcher m = SObjM.valueOf(Opportunity.CloseDate).must(new BeFirstDayOfMonth());
```

### Built-in matchers

Here is a list of the built-in matchers that are ready to use.

#### Available by valueOf() and priorValueOf()

- betweenExcl(Object, Object) - numeric types
- betweenIncl(Object, Object) - numeric types
- blank()
- contains(String)
- containsIgnoreCase(String)
- empty()
- endsWith(String)
- endsWithIgnoreCase(String)
- equals(Object)
- equalsAny(Object[])
- equalsAnyIgnoreCase(List<String>)
- equalsIgnoreCase(String)
- equalsNone(Object[])
- equalsNoneIgnoreCase(List<String>)
- greater(Object) - numeric types
- greaterEquals(Object) - numeric types
- length(Integer)
- lengthBetween(Integer, Integer)
- less(Object) - numeric types
- lessEquals(Object) - numeric types
- maxLength(Integer)
- minLength(Integer)
- must(SObjM.Matcher) - for custom matchers
- mustNot(SObjM.Matcher) - for custom matchers
- nil()
- notBlank()
- notContains(String)
- notContainsIgnoreCase(String)
- notEmpty()
- notEquals(Object)
- notEqualsIgnoreCase(String)
- notNil()
- outsideExcl(Object, Object) - numeric types
- outsideIncl(Object, Object) - numeric types
- regex(String)
- startsWith(String)
- startsWithIgnoreCase(String)

#### Available by valueOf()

Will always return false if old sObject is not passed.

- changed()
- changedFrom(Object)
- changedFromAny(Object[])
- changedFromAnyTo(Object[], Object)
- changedFromAnyToAny(Object[], Object[]>)
- changedFromTo(Object, Object)
- changedFromToAny(Object, Object[])
- changedTo(Object)
- changedToAny(Object[])

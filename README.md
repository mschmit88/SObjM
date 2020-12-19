# SObjM (or SObject Matcher)

## Intention

I always disliked that I have to write lots boilerplate code to extract certain records from a list of sObjects. Apart from that, the code is not easy to read as soon as the logic becomes more complex which makes it hard to find bugs.

A requirement could look like this:

Extract accounts:

- having an annual revenue between 200k and 300k
- and are of type "Partner"
- and whose billing country is Germany

So the code typically looks like this:

```javascript
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

Adding some or-conditions or dealing with old and new versions of sObjects in triggers will make it very easy to introduce bugs that are hard to find.

## Solution

For some time, I had been googling to find a project that solves this problem but never really found a solution that had the functionalities I was looking for.

So being forced to stay at home during the COVID pandemic gave me some time to come up with a solution that fits (most of) my requirements.

The outcome is just one class that has zero dependencies and can be used in any org. New matchers can be implmented by extending the SObjM.Matcher class. Keep reading and further information ;)

The previous example using this class looks like this:

```javascript
List<Account> accs = // Trigger.new or wherever they came from
List<Account> accsFiltered = (List<Account>) SObjM.and_x(
        SObjM.val(Account.AnnualRevenue).betweenIncl(200000, 300000),
        SObjM.val(Account.Type).equals('Partner'),
        SObjM.val(Account.BillingCountry).equals('Germany')
    ).matches(accs);
```

I will be more than happy for feedback and maybe even ideas for new functionalities that I have missed :)

## Documentation

### Installation

Just copy paste both classes SObjM and SObjM_T into your org and you are ready to go.

### Instantiating a matcher

There are 5 ways to instantiate a matcher:

#### val()

Using this method, you can create a matcher who matches on a sObject.

Example:

```javascript
SObjM.Matcher matcher = SObjM.val(Account.Name).equals('xyz');
```

#### priorVal()

Using this method, you can create a matcher who matches the old sObject if present. If old sObject is not present, it will behave just like val().

Example:

```javascript
SObjM.Matcher matcher = SObjM.priorVal(Account.Name).equals('xyz');
```

#### not_x()

Using this method, you can create a matcher who negates the matcher that is passed into it.

Example:

```javascript
SObjM.Matcher matcher = SObjM.not_x( SObjM.val(Account.Name).equals('xyz') );
```

#### and_x()

Using this method, you can create a matcher who groups all passed matchers by an and-operation.

Example:

```javascript
SObjM.Matcher matcher = SObjM.and_x(
    SObjM.val(Account.Name).equals('xyz'),
    SObjM.val(Account.Type).notEquals('abc'));
```

Up to 5 matchers can be passed without the need to create a list of matchers. For more than 5 matchers, the code looks like this:

```javascript
SObjM.Matcher matcher = SObjM.and_x(new Set<SObjM.Matcher> {
        SObjM.val(Account.Name).notEquals('1'),
        SObjM.val(Account.Type).notEquals('2')),
        SObjM.val(Account.Type).notEquals('3')),
        SObjM.val(Account.Type).notEquals('4')),
        SObjM.val(Account.Type).notEquals('5')),
        SObjM.val(Account.Type).notEquals('6'))
    });

```

#### or_x()

Same as and_x but or_x ;)

### Using a matcher

As you have instantiated a matcher, you want to use it on one or multiple sObjects.

To do so, you have four methods.

#### Boolean matches(SObject)

If you need to check if <b>one</b> sObject meets certain criterias, then use this method.

Example:

```javascript
SObjM.Matcher accNameIsXyz = SObjM.val(Account.Name).equals('xyz');

if(accNameIsXyz.matches(someAccount)) {
    // it matches!
}
```

#### Boolean matches(SObject, SObject)

If you need to check if <b>one</b> sObject meets certain criterias and also need to check the <b>old version</b> of the sObject, then use this method.

Example:

```javascript
SObjM.Matcher accountNameChangedFromNewToOld = SObjM.and_x(
    SObjM.val(Account.Name).equals('new'),
    SObjM.priorVal(Account.Name).equals('old'));

if(accountNameChangedFromNewToOld.matches(newAccount, oldAccount)) {
    // it matches!
}
```

#### SObjM.Result matches(List<SObject>)

If you need to check if <b>multiple</b> sObjects meet certain criterias, then use this method.

Example:

```javascript
SObjM.Matcher accNameIsXyz = SObjM.val(Account.Name).equals('xyz');
SObjM.Result res = accNameIsXyz.matches(accounts);

List<Account> matchingAccounts = (List<Account>) res.hits;
List<Account> nonMatchingAccounts = (List<Account>) res.misses;
```

#### Boolean matches(List<SObject>, Map<Id, SObject>)

If you need to check if <b>multiple</b> sObjects meet certain criterias and you also need to check the <b>old version</b> of the sObject, then use this method.

Example:

```javascript
SObjM.Matcher accountNameChangedFromNewToOld = SObjM.and_x(
    SObjM.val(Account.Name).equals('new'),
    SObjM.priorVal(Account.Name).equals('old'));

SObjM.Result res = accountNameChangedFromNewToOld.matches(newAccounts, oldAccountsById);

List<Account> matchingAccounts = (List<Account>) res.hits;
List<Account> nonMatchingAccounts = (List<Account>) res.misses;
```

### Creating a custom matcher

If the built-in matchers do not meet your requirement, then you can easily create a custom matcher by extending the SObjM.Matcher class.

Example:

```javascript
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

```javascript
SObjM.Matcher m = SObjM.val(Opportunity.CloseDate).must(new BeFirstDayOfMonth());
```

### Built-in matchers

Here is a list of the built-in matchers that are ready to use.

#### Available by val() and priorVal()

- betweenExcl(Object, Object) - numeric types
- betweenIncl(Object, Object) - numeric types
- blank()
- contains(String)
- containsIgnoreCase(String)
- empty()
- endsWith(String)
- endsWithIgnoreCase(String)
- equals(Object)
- equals(Object[])
- equalsIgnoreCase(String)
- equalsIgnoreCase(String[])
- equalsNone(Object[])
- equalsNoneIgnoreCase(String[])
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

#### Available by val()

Will always return false if old sObject is not passed.

- changed()
- changedFrom(Object)
- changedFrom(Object[])
- changedFromTo(Object, Object)
- changedFromTo(Object[], Object)
- changedFromTo(Object, Object[])
- changedFromTo(Object[], Object[]>)
- changedTo(Object)
- changedTo(Object[])

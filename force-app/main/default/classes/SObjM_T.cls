@IsTest
private class SObjM_T {

    /**
    * and_x
    */

    @IsTest
    static void and_match() {
        System.assert(
            SObjM.and_x(
                SObjM.valueOf(Account.Name).equalsAny(new List<String>{ 'Some Name', 'Some different Name'}),
                SObjM.valueOf(Account.Industry).equals('Some Industry')
            ).matches(new Account(Name = 'Some Name', Industry = 'Some Industry'))
        );
    }

    @IsTest
    static void and_multiple() {
        SObjM.Matcher m = SObjM.valueOf(Account.Name).equals('Test');
        System.assert(SObjM.and_x(m, m, m, m, m).matches(new Account(Name = 'Test')));
        System.assert(SObjM.and_x(m, m, m, m).matches(new Account(Name = 'Test')));
        System.assert(SObjM.and_x(m, m, m).matches(new Account(Name = 'Test')));
    }

    @IsTest
    static void and_noMatch() {
        System.assert(
            ! SObjM.and_x(new Set<SObjM.Matcher>{
                SObjM.valueOf(Account.Name).equalsAny(new List<String>{ 'Some Name', 'Some different Name'}),
                SObjM.valueOf(Account.Industry).equals('Some different Industry')
            }).matches(new Account(Name = 'Some Name', Industry = 'Some Industry'))
        );
    }

    @IsTest
    static void and_listOldNew() {
        Account acc1 = new Account(Name = 'A', AnnualRevenue = 100, Id = getFakeId(Account.SObjectType));
        Account acc2 = new Account(Name = 'A', AnnualRevenue = 101, Id = getFakeId(Account.SObjectType));

        Account acc1Old = acc1.clone(true);
        acc1Old.Name = 'A old';
        Account acc2Old = acc2.clone(true);
        acc2Old.Name = 'A old';

        SObjM.Result res = SObjM.and_x(
                                SObjM.valueOf(Account.Name).changedTo('A'),
                                SObjM.valueOf(Account.AnnualRevenue).equals(100)
                            ).matches(
                                new List<Account>{ acc1, acc2 },
                                new Map<Id, Account>(new List<Account>{ acc1Old, acc2Old }));

        System.assertEquals(1, res.hits.size());
        System.assertEquals(1, res.misses.size());

        System.assertEquals(100, ((Account) res.hits[0]).AnnualRevenue);
        System.assertEquals(101, ((Account) res.misses[0]).AnnualRevenue);
    }

    /**
    * or_x
    */

    @IsTest
    static void or_match() {
        System.assert(
            SObjM.or_x(
                SObjM.valueOf(Account.Name).equalsAny(new List<String>{ 'Some different Name'}),
                SObjM.valueOf(Account.Industry).equals('Some Industry')
            ).matches(new Account(Name = 'Some Name', Industry = 'Some Industry'))
        );
    }

    @IsTest
    static void or_multiple() {
        SObjM.Matcher m = SObjM.valueOf(Account.Name).equals('Test');
        System.assert(SObjM.or_x(m, m, m, m, m).matches(new Account(Name = 'Test')));
        System.assert(SObjM.or_x(m, m, m, m).matches(new Account(Name = 'Test')));
        System.assert(SObjM.or_x(m, m, m).matches(new Account(Name = 'Test')));
    }

    @IsTest
    static void or_noMatch() {
        System.assert(
            ! SObjM.or_x(new Set<SObjM.Matcher>{
                SObjM.valueOf(Account.Name).equalsAny(new List<String>{ 'Some different Name'}),
                SObjM.valueOf(Account.Industry).equals('Some different Industry')
            }).matches(new Account(Name = 'Some Name', Industry = 'Some Industry'))
        );
    }

    @IsTest
    static void or_listOldNew() {
        Account acc1 = new Account(Name = 'A', AnnualRevenue = 100, Id = getFakeId(Account.SObjectType));
        Account acc2 = new Account(Name = 'B', AnnualRevenue = 101, Id = getFakeId(Account.SObjectType));

        Account acc1Old = acc1.clone(true);
        acc1Old.Name = 'A old';
        Account acc2Old = acc2.clone(true);
        acc2Old.Name = 'B old';

        SObjM.Result res = SObjM.or_x(
                                SObjM.valueOf(Account.Name).changedTo('A'),
                                SObjM.valueOf(Account.AnnualRevenue).equals(100)
                            ).matches(
                                new List<Account>{ acc1, acc2 },
                                new Map<Id, Account>(new List<Account>{ acc1Old, acc2Old })
                            );

        System.assertEquals(1, res.hits.size());
        System.assertEquals(1, res.misses.size());

        System.assertEquals(100, ((Account) res.hits[0]).AnnualRevenue);
        System.assertEquals(101, ((Account) res.misses[0]).AnnualRevenue);
    }

    /**
    * not_x
    */

    @IsTest
    static void not_match() {
        System.assert(SObjM.not_x(SObjM.valueOf(Account.Name).equals('A')).matches(new Account(Name = 'B')));
    }

    @IsTest
    static void not_noMatch() {
        System.assert(! SObjM.not_x(SObjM.valueOf(Account.Name).equals('A')).matches(new Account(Name = 'A')));
    }

    /**
    * equals
    */

    @IsTest
    static void equals_match() {
        System.assert(SObjM.valueOf(Account.Name).equals('Some Name').matches(new Account(Name = 'Some Name')));
    }

    @IsTest
    static void equals_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).equals('Some Name').matches(new Account(Name = 'Some different Name')));
    }

    @IsTest
    static void equals_caseSensitive() {
        System.assert(! SObjM.valueOf(Account.Name).equals('Some Name').matches(new Account(Name = 'some name')));
    }

    @IsTest
    static void equals_Number() {
        System.assert(SObjM.valueOf(Account.AnnualRevenue).equals(100).matches(new Account(AnnualRevenue = 100.0)));
    }

    /**
    * equalsIgnoreCase
    */

    @IsTest
    static void equalsIgnoreCase_match() {
        System.assert(SObjM.valueOf(Account.Name).equalsIgnoreCase('Some Name').matches(new Account(Name = 'some Name')));
    }

    @IsTest
    static void equalsIgnoreCase_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).equalsIgnoreCase('Some Name').matches(new Account(Name = 'Some different Name')));
    }

    /**
    * notEquals
    */

    @IsTest
    static void notEquals_match() {
        System.assert(SObjM.valueOf(Account.Name).notEquals('Some Name').matches(new Account(Name = 'Some different Name')));
    }

    @IsTest
    static void notEquals_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).notEquals('Some Name').matches(new Account(Name = 'Some Name')));
    }

    @IsTest
    static void notEquals_caseSensitive() {
        System.assert(SObjM.valueOf(Account.Name).notEquals('Some Name').matches(new Account(Name = 'some Name')));
    }

    /**
    * notEqualsIgnoreCase
    */

    @IsTest
    static void notEqualsIgnoreCase_match() {
        System.assert(SObjM.valueOf(Account.Name).notEqualsIgnoreCase('Some Name').matches(new Account(Name = 'some different Name')));
    }

    @IsTest
    static void notEqualsIgnoreCase_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).notEqualsIgnoreCase('Some Name').matches(new Account(Name = 'some name')));
    }

    /**
    * regex
    */

    @IsTest
    static void regex_match() {
        System.assert(SObjM.valueOf(Account.Name).regex('^[0-9]+$').matches(new Account(Name = '12345')));
    }

    @IsTest
    static void regex_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).regex('^[0-9]+$').matches(new Account(Name = 'Some Name')));
    }

    /**
    * length
    */

    @IsTest
    static void length_match() {
        System.assert(SObjM.valueOf(Account.Name).length(5).matches(new Account(Name = '12345')));
    }

    @IsTest
    static void length_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).length(5).matches(new Account(Name = '1234')));
    }

    @IsTest
    static void length_exception() {
        try {
            SObjM.valueOf(Account.Name).length(null);
            System.assert(false);
        }
        catch(Exception e) { }
    }

    @IsTest
    static void length_valueNull() {
        System.assert(! SObjM.valueOf(Account.Name).length(1).matches(new Account(Name = null)));
    }

    /**
    * minLength
    */

    @IsTest
    static void minLength_match() {
        System.assert(SObjM.valueOf(Account.Name).minLength(5).matches(new Account(Name = '12345')));
    }

    @IsTest
    static void minLength_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).minLength(5).matches(new Account(Name = '1234')));
    }

    @IsTest
    static void minLength_exception() {
        try {
            SObjM.valueOf(Account.Name).minLength(null);
            System.assert(false);
        }
        catch(Exception e) { }
    }

    @IsTest
    static void minLength_valueNull() {
        System.assert(! SObjM.valueOf(Account.Name).minLength(1).matches(new Account(Name = null)));
    }

    /**
    * maxLength
    */

    @IsTest
    static void maxLength_match() {
        System.assert(SObjM.valueOf(Account.Name).maxLength(5).matches(new Account(Name = '12345')));
    }

    @IsTest
    static void maxLength_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).maxLength(5).matches(new Account(Name = '123456')));
    }

    @IsTest
    static void maxLength_exception() {
        try {
            SObjM.valueOf(Account.Name).maxLength(null);
            System.assert(false);
        }
        catch(Exception e) { }
    }

    @IsTest
    static void maxLength_valueNull() {
        System.assert(! SObjM.valueOf(Account.Name).maxLength(5).matches(new Account(Name = null)));
    }

    /**
    * lengthBetween
    */

    @IsTest
    static void lengthBetween_match() {
        System.assert(SObjM.valueOf(Account.Name).lengthBetween(1, 5).matches(new Account(Name = '12345')));
    }

    @IsTest
    static void lengthBetween_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).lengthBetween(1, 5).matches(new Account(Name = '123456')));
    }

    @IsTest
    static void lengthBetween_exception() {
        try {
            SObjM.valueOf(Account.Name).lengthBetween(null, null);
            System.assert(false);
        }
        catch(Exception e) { }
    }

    @IsTest
    static void lengthBetween_valueNull() {
        System.assert(! SObjM.valueOf(Account.Name).lengthBetween(1, 5).matches(new Account(Name = null)));
    }

    /**
    * contains
    */

    @IsTest
    static void contains_match() {
        System.assert(SObjM.valueOf(Account.Name).contains('Some').matches(new Account(Name = 'Some Name')));
    }

    @IsTest
    static void contains_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).contains('Foo').matches(new Account(Name = 'Some Name')));
    }

    @IsTest
    static void contains_caseSensitive() {
        System.assert(! SObjM.valueOf(Account.Name).contains('some').matches(new Account(Name = 'Some Name')));
    }

    /**
    * notContains
    */

    @IsTest
    static void notContains_match() {
        System.assert(SObjM.valueOf(Account.Name).notContains('Foo').matches(new Account(Name = 'Some Name')));
    }

    @IsTest
    static void notContains_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).notContains('Some').matches(new Account(Name = 'Some Name')));
    }

    @IsTest
    static void notContains_caseSensitive() {
        System.assert(SObjM.valueOf(Account.Name).notContains('some').matches(new Account(Name = 'Some Name')));
    }

    /**
    * containsIgnoreCase
    */

    @IsTest
    static void containsIgnoreCase_match() {
        System.assert(SObjM.valueOf(Account.Name).containsIgnoreCase('some').matches(new Account(Name = 'Some Name')));
    }

    @IsTest
    static void containsIgnoreCase_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).containsIgnoreCase('Foo').matches(new Account(Name = 'Some Name')));
    }

    /**
    * notContainsIgnoreCase
    */

    @IsTest
    static void notContainsIgnoreCase_match() {
        System.assert(SObjM.valueOf(Account.Name).notContainsIgnoreCase('Foo').matches(new Account(Name = 'Some Name')));
    }

    @IsTest
    static void notContainsIgnoreCase_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).notContainsIgnoreCase('some').matches(new Account(Name = 'Some Name')));
    }

    /**
    * nil
    */

    @IsTest
    static void nil_match() {
        System.assert(SObjM.valueOf(Account.Name).nil().matches(new Account(Name = null)));
    }

    @IsTest
    static void nil_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).nil().matches(new Account(Name = 'Some Name')));
    }

    /**
    * notNil
    */

    @IsTest
    static void notNil_match() {
        System.assert(SObjM.valueOf(Account.Name).notNil().matches(new Account(Name = 'Some Name')));
    }

    @IsTest
    static void notNil_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).notNil().matches(new Account(Name = null)));
    }

    /**
    * empty
    */

    @IsTest
    static void empty_match() {
        System.assert(SObjM.valueOf(Account.Name).empty().matches(new Account(Name = '')));
    }

    @IsTest
    static void empty_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).empty().matches(new Account(Name = 'Some Name')));
    }

    /**
    * notEmpty
    */

    @IsTest
    static void notEmpty_match() {
        System.assert(SObjM.valueOf(Account.Name).notEmpty().matches(new Account(Name = 'Some Name')));
    }

    @IsTest
    static void notEmpty_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).notEmpty().matches(new Account(Name = '')));
    }

    /**
    * blank
    */

    @IsTest
    static void blank_match() {
        System.assert(SObjM.valueOf(Account.Name).blank().matches(new Account(Name = ' ')));
    }

    @IsTest
    static void blank_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).blank().matches(new Account(Name = 'Some Name')));
    }

    /**
    * notBlank
    */

    @IsTest
    static void notBlank_match() {
        System.assert(SObjM.valueOf(Account.Name).notBlank().matches(new Account(Name = 'Some Name')));
    }

    @IsTest
    static void notBlank_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).notBlank().matches(new Account(Name = ' ')));
    }

    /**
    * equalsAny
    */

    @IsTest
    static void equalsAny_match() {
        System.assert(SObjM.valueOf(Account.Name).equalsAny(new List<String>{ 'A', 'B' }).matches(new Account(Name = 'A')));
    }

    @IsTest
    static void equalsAny_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).equalsAny(new List<String>{ 'A', 'B' }).matches(new Account(Name = 'C')));
    }

    @IsTest
    static void equalsAny_caseSensitive() {
        System.assert(! SObjM.valueOf(Account.Name).equalsAny(new List<String>{ 'A', 'B' }).matches(new Account(Name = 'a')));
    }

    @IsTest
    static void equalsAny_Number() {
        System.assert(SObjM.valueOf(Account.AnnualRevenue).equalsAny(new List<Integer>{ 100, 200 }).matches(new Account(AnnualRevenue = 100.0)));
    }

    /**
    * equalsAnyIgnoreCase
    */

    @IsTest
    static void equalsAnyIgnoreCase_match() {
        System.assert(SObjM.valueOf(Account.Name).equalsAnyIgnoreCase(new List<String>{ 'A', 'B' }).matches(new Account(Name = 'a')));
    }

    @IsTest
    static void equalsAnyIgnoreCase_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).equalsAnyIgnoreCase(new List<String>{ 'A', 'B' }).matches(new Account(Name = 'C')));
    }

    /**
    * equalsNone
    */

    @IsTest
    static void equalsNone_match() {
        System.assert(SObjM.valueOf(Account.Name).equalsNone(new List<String>{ 'A', 'B' }).matches(new Account(Name = 'a')));
    }

    @IsTest
    static void equalsNone_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).equalsNone(new List<String>{ 'A', 'B' }).matches(new Account(Name = 'A')));
    }

    @IsTest
    static void equalsNone_Number() {
        System.assert(SObjM.valueOf(Account.AnnualRevenue).equalsNone(new List<Integer>{ 101, 200 }).matches(new Account(AnnualRevenue = 100.0)));
    }

    @IsTest
    static void equalsNone_Number_noMatch() {
        System.assert(! SObjM.valueOf(Account.AnnualRevenue).equalsNone(new List<Integer>{ 101, 200 }).matches(new Account(AnnualRevenue = 101.0)));
    }

    /**
    * equalsNoneIgnoreCase
    */

    @IsTest
    static void equalsNoneIgnoreCase_match() {
        System.assert(SObjM.valueOf(Account.Name).equalsNoneIgnoreCase(new List<String>{ 'A', 'B' }).matches(new Account(Name = 'C')));
    }

    @IsTest
    static void equalsNoneIgnoreCase_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).equalsNoneIgnoreCase(new List<String>{ 'A', 'B' }).matches(new Account(Name = 'a')));
    }

    /**
    * startsWith
    */

    @IsTest
    static void startsWith_match() {
        System.assert(SObjM.valueOf(Account.Name).startsWith('So').matches(new Account(Name = 'Some Name')));
    }

    @IsTest
    static void startsWith_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).startsWith('so').matches(new Account(Name = 'Some Name')));
    }

    /**
    * startsWithIgnoreCase
    */

    @IsTest
    static void startsWithIgnoreCase_match() {
        System.assert(SObjM.valueOf(Account.Name).startsWithIgnoreCase('so').matches(new Account(Name = 'Some Name')));
    }

    @IsTest
    static void startsWithIgnoreCase_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).startsWithIgnoreCase('Foo').matches(new Account(Name = 'Some Name')));
    }

    /**
    * endsWith
    */

    @IsTest
    static void endsWith_match() {
        System.assert(SObjM.valueOf(Account.Name).endsWith('Name').matches(new Account(Name = 'Some Name')));
    }

    @IsTest
    static void endsWith_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).endsWith('name').matches(new Account(Name = 'Some Name')));
    }

    /**
    * endsWithIgnoreCase
    */

    @IsTest
    static void endsWithIgnoreCase_match() {
        System.assert(SObjM.valueOf(Account.Name).endsWithIgnoreCase('name').matches(new Account(Name = 'Some Name')));
    }

    @IsTest
    static void endsWithIgnoreCase_noMatch() {
        System.assert(! SObjM.valueOf(Account.Name).endsWithIgnoreCase('Foo').matches(new Account(Name = 'Some Name')));
    }

    /**
    * greater
    */

    @IsTest
    static void greater_match() {
        System.assert(SObjM.valueOf(Account.AnnualRevenue).greater(99).matches(new Account(AnnualRevenue = 100)));
    }

    @IsTest
    static void greater_noMatch() {
        System.assert(! SObjM.valueOf(Account.AnnualRevenue).greater(100).matches(new Account(AnnualRevenue = 100)));
    }

    @IsTest
    static void greater_Date() {
        System.assert(SObjM.valueOf(Contact.Birthdate).greater(Date.newInstance(2021, 1, 1)).matches(new Contact(Birthdate = Date.newInstance(2021, 1, 2))));
    }

    /**
    * less
    */

    @IsTest
    static void less_match() {
        System.assert(SObjM.valueOf(Account.AnnualRevenue).less(100).matches(new Account(AnnualRevenue = 99)));
    }

    @IsTest
    static void less_noMatch() {
        System.assert(! SObjM.valueOf(Account.AnnualRevenue).less(99).matches(new Account(AnnualRevenue = 100)));
    }

    @IsTest
    static void less_Date() {
        System.assert(SObjM.valueOf(Contact.Birthdate).less(Date.newInstance(2021, 1, 2)).matches(new Contact(Birthdate = Date.newInstance(2021, 1, 1))));
    }

    /**
    * greaterEquals
    */

    @IsTest
    static void greaterEquals_match() {
        System.assert(SObjM.valueOf(Account.AnnualRevenue).greaterEquals(100).matches(new Account(AnnualRevenue = 100)));
    }

    @IsTest
    static void greaterEquals_noMatch() {
        System.assert(! SObjM.valueOf(Account.AnnualRevenue).greaterEquals(100).matches(new Account(AnnualRevenue = 99)));
    }

    @IsTest
    static void greaterEquals_Date() {
        System.assert(SObjM.valueOf(Contact.Birthdate).greaterEquals(Date.newInstance(2021, 1, 1)).matches(new Contact(Birthdate = Date.newInstance(2021, 1, 1))));
    }

    /**
    * lessEquals
    */

    @IsTest
    static void lessEquals_match() {
        System.assert(SObjM.valueOf(Account.AnnualRevenue).lessEquals(100).matches(new Account(AnnualRevenue = 100)));
    }

    @IsTest
    static void lessEquals_noMatch() {
        System.assert(! SObjM.valueOf(Account.AnnualRevenue).lessEquals(100).matches(new Account(AnnualRevenue = 101)));
    }

    @IsTest
    static void lessEquals_Date() {
        System.assert(SObjM.valueOf(Contact.Birthdate).lessEquals(Date.newInstance(2021, 1, 2)).matches(new Contact(Birthdate = Date.newInstance(2021, 1, 1))));
    }

    /**
    * betweenIncl
    */

    @IsTest
    static void betweenIncl_match() {
        System.assert(SObjM.valueOf(Account.AnnualRevenue).betweenIncl(1, 2).matches(new Account(AnnualRevenue = 1)));
    }

    @IsTest
    static void betweenIncl_noMatch() {
        System.assert(! SObjM.valueOf(Account.AnnualRevenue).betweenIncl(1, 2).matches(new Account(AnnualRevenue = 0)));
    }

    @IsTest
    static void betweenIncl_Date() {
        System.assert(
            SObjM.valueOf(Contact.Birthdate)
                    .betweenIncl(Date.newInstance(2021, 1, 1), Date.newInstance(2021, 1, 2))
                    .matches(new Contact(Birthdate = Date.newInstance(2021, 1, 1)))
        );
    }

    /**
    * betweenExcl
    */

    @IsTest
    static void betweenExcl_match() {
        System.assert(SObjM.valueOf(Account.AnnualRevenue).betweenExcl(1, 3).matches(new Account(AnnualRevenue = 2)));
    }

    @IsTest
    static void betweenExcl_noMatch() {
        System.assert(! SObjM.valueOf(Account.AnnualRevenue).betweenExcl(1, 3).matches(new Account(AnnualRevenue = 1)));
    }

    @IsTest
    static void betweenExcl_Date() {
        System.assert(
            SObjM.valueOf(Contact.Birthdate)
                    .betweenExcl(Date.newInstance(2021, 1, 1), Date.newInstance(2021, 1, 3))
                    .matches(new Contact(Birthdate = Date.newInstance(2021, 1, 2)))
        );
    }

    /**
    * outsideIncl
    */

    @IsTest
    static void outsideIncl_match() {
        System.assert(SObjM.valueOf(Account.AnnualRevenue).outsideIncl(1, 3).matches(new Account(AnnualRevenue = 1)));
    }

    @IsTest
    static void outsideIncl_noMatch() {
        System.assert(! SObjM.valueOf(Account.AnnualRevenue).outsideIncl(1, 3).matches(new Account(AnnualRevenue = 2)));
    }

    @IsTest
    static void outsideIncl_Date() {
        System.assert(
            SObjM.valueOf(Contact.Birthdate)
                    .outsideIncl(Date.newInstance(2021, 1, 1), Date.newInstance(2021, 1, 2))
                    .matches(new Contact(Birthdate = Date.newInstance(2021, 1, 1)))
        );
    }

    /**
    * outsideExcl
    */

    @IsTest
    static void outsideExcl_match() {
        System.assert(SObjM.valueOf(Account.AnnualRevenue).outsideExcl(1, 3).matches(new Account(AnnualRevenue = 0)));
    }

    @IsTest
    static void outsideExcl_noMatch() {
        System.assert(! SObjM.valueOf(Account.AnnualRevenue).outsideExcl(1, 3).matches(new Account(AnnualRevenue = 2)));
    }

    @IsTest
    static void outsideExcl_Date() {
        System.assert(
            SObjM.valueOf(Contact.Birthdate)
                    .outsideExcl(Date.newInstance(2021, 1, 2), Date.newInstance(2021, 1, 4))
                    .matches(new Contact(Birthdate = Date.newInstance(2021, 1, 1)))
        );
    }

    /**
    * must
    */

    private class BeFirstDayOfYear extends SObjM.Matcher {
        private BeFirstDayOfYear() { }

        protected override Boolean matchesImpl(SObject sObj) {
            Date dt = (Date) sObj.get(this.field);
            return dt.day() == 1 && dt.month() == 1;
        }
    }

    @IsTest
    static void must_match() {
        System.assert(SObjM.valueOf(Contact.Birthdate).must(new BeFirstDayOfYear()).matches(new Contact(Birthdate = Date.newInstance(2021, 1, 1))));
    }

    @IsTest
    static void must_noMatch() {
        System.assert(! SObjM.valueOf(Contact.Birthdate).must(new BeFirstDayOfYear()).matches(new Contact(Birthdate = Date.newInstance(2021, 1, 2))));
    }

    /**
    * mustNot
    */

    @IsTest
    static void mustNot_match() {
        System.assert(SObjM.valueOf(Contact.Birthdate).mustNot(new BeFirstDayOfYear()).matches(new Contact(Birthdate = Date.newInstance(2021, 1, 2))));
    }

    @IsTest
    static void mustNot_noMatch() {
        System.assert(! SObjM.valueOf(Contact.Birthdate).mustNot(new BeFirstDayOfYear()).matches(new Contact(Birthdate = Date.newInstance(2021, 1, 1))));
    }

    /**
    * changed
    */

    @IsTest
    static void changed_match() {
        System.assert(
            SObjM.valueOf(Account.Name)
                    .changed()
                    .matches(new Account(Name = 'New'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changed_noMatch() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changed()
                    .matches(new Account(Name = 'Old'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changed_noOldValue() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changed()
                    .matches(new Account(Name = 'Some Name'))
        );
    }

    @IsTest
    static void changed_match_Number() {
        System.assert(
            SObjM.valueOf(Account.AnnualRevenue)
                    .changed()
                    .matches(new Account(AnnualRevenue = 100), new Account(AnnualRevenue = 101))
        );
    }

    /**
    * changedFrom
    */

    @IsTest
    static void changedFrom_match() {
        System.assert(
            SObjM.valueOf(Account.Name)
                    .changedFrom('Old')
                    .matches(new Account(Name = 'New'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedFrom_noMatch() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedFrom('Old')
                    .matches(new Account(Name = 'Old'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedFrom_noOldValue() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedFrom('still same')
                    .matches(new Account(Name = 'still same'))
        );
    }

    @IsTest
    static void changedFrom_match_Number() {
        System.assert(
            SObjM.valueOf(Account.AnnualRevenue)
                    .changedFrom(100)
                    .matches(new Account(AnnualRevenue = 101), new Account(AnnualRevenue = 100))
        );
    }

    /**
    * changedFromAny
    */

    @IsTest
    static void changedFromAny_match() {
        System.assert(
            SObjM.valueOf(Account.Name)
                    .changedFromAny(new List<String>{ 'Old' })
                    .matches(new Account(Name = 'New'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedFromAny_noMatch() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedFromAny(new List<String>{ 'Old' })
                    .matches(new Account(Name = 'Old'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedFromAny_noOldValue() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedFromAny(new List<String>{ 'still same' })
                    .matches(new Account(Name = 'still same'))
        );
    }

    @IsTest
    static void changedFromAny_match_Number() {
        System.assert(
            SObjM.valueOf(Account.AnnualRevenue)
                    .changedFromAny(new List<Integer>{ 100 })
                    .matches(new Account(AnnualRevenue = 101), new Account(AnnualRevenue = 100))
        );
    }

    /**
    * changedTo
    */

    @IsTest
    static void changedTo_match() {
        System.assert(
            SObjM.valueOf(Account.Name)
                    .changedTo('New')
                    .matches(new Account(Name = 'New'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedTo_noMatch() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedTo('Old')
                    .matches(new Account(Name = 'Old'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedTo_noOldValue() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedTo('still same')
                    .matches(new Account(Name = 'still same'))
        );
    }

    @IsTest
    static void changedTo_match_Number() {
        System.assert(
            SObjM.valueOf(Account.AnnualRevenue)
                    .changedTo(101)
                    .matches(new Account(AnnualRevenue = 101), new Account(AnnualRevenue = 100))
        );
    }

    /**
    * changedToAny
    */

    @IsTest
    static void changedToAny_match() {
        System.assert(
            SObjM.valueOf(Account.Name)
                    .changedToAny(new List<String>{ 'New' })
                    .matches(new Account(Name = 'New'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedToAny_noMatch() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedToAny(new List<String>{ 'Old' })
                    .matches(new Account(Name = 'Old'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedToAny_noOldValue() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedToAny(new List<String>{ 'still same' })
                    .matches(new Account(Name = 'still same'))
        );
    }

    @IsTest
    static void changedToAny_match_Number() {
        System.assert(
            SObjM.valueOf(Account.AnnualRevenue)
                    .changedToAny(new List<Integer>{ 101 })
                    .matches(new Account(AnnualRevenue = 101), new Account(AnnualRevenue = 100))
        );
    }

    /**
    * changedFromTo
    */

    @IsTest
    static void changedFromTo_match() {
        System.assert(
            SObjM.valueOf(Account.Name)
                    .changedFromTo('Old', 'New')
                    .matches(new Account(Name = 'New'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedFromTo_noMatch() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedFromTo('Old', 'New')
                    .matches(new Account(Name = 'Old'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedFromTo_noOldValue() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedFromTo('Old', 'New')
                    .matches(new Account(Name = 'still same'))
        );
    }

    @IsTest
    static void changedFromTo_match_Number() {
        System.assert(
            SObjM.valueOf(Account.AnnualRevenue)
                    .changedFromTo(100, 101)
                    .matches(new Account(AnnualRevenue = 101), new Account(AnnualRevenue = 100))
        );
    }

    /**
    * changedFromAnyTo
    */

    @IsTest
    static void changedFromAnyTo_match() {
        System.assert(
            SObjM.valueOf(Account.Name)
                    .changedFromAnyTo(new List<String>{ 'Old' }, 'New')
                    .matches(new Account(Name = 'New'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedFromAnyTo_noMatch() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedFromAnyTo(new List<String>{ 'Old' }, 'Old')
                    .matches(new Account(Name = 'Old'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedFromAnyTo_noOldValue() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedFromAnyTo(new List<String>{ 'still same' }, 'still same')
                    .matches(new Account(Name = 'still same'))
        );
    }

    @IsTest
    static void changedFromAnyTo_match_Number() {
        System.assert(
            SObjM.valueOf(Account.AnnualRevenue)
                    .changedFromAnyTo(new List<Integer>{ 100 }, 101)
                    .matches(new Account(AnnualRevenue = 101), new Account(AnnualRevenue = 100))
        );
    }

    /**
    * changedFromToAny
    */

    @IsTest
    static void changedFromToAny_match() {
        System.assert(
            SObjM.valueOf(Account.Name)
                    .changedFromToAny('Old', new List<String>{ 'New' })
                    .matches(new Account(Name = 'New'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedFromToAny_noMatch() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedFromToAny('Old', new List<String>{ 'Old' })
                    .matches(new Account(Name = 'Old'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedFromToAny_noOldValue() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedFromToAny('still same', new List<String>{ 'still same' })
                    .matches(new Account(Name = 'still same'))
        );
    }

    @IsTest
    static void changedFromToAny_match_Number() {
        System.assert(
            SObjM.valueOf(Account.AnnualRevenue)
                    .changedFromToAny(100, new List<Integer>{ 101 })
                    .matches(new Account(AnnualRevenue = 101), new Account(AnnualRevenue = 100))
        );
    }

    /**
    * changedFromAnyToAny
    */

    @IsTest
    static void changedFromAnyToAny_match() {
        System.assert(
            SObjM.valueOf(Account.Name)
                .changedFromAnyToAny(new List<String>{ 'Old' }, new List<String>{ 'New' })
                .matches(new Account(Name = 'New'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedFromAnyToAny_noMatch() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedFromAnyToAny(new List<String>{ 'Old' }, new List<String>{ 'Old' })
                    .matches(new Account(Name = 'Old'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void changedFromAnyToAny_noOldValue() {
        System.assert(
            ! SObjM.valueOf(Account.Name)
                    .changedFromAnyToAny(new List<String>{ 'still same' }, new List<String>{ 'still same' })
                    .matches(new Account(Name = 'still same'))
        );
    }

    @IsTest
    static void changedFromAnyToAny_match_Number() {
        System.assert(
            SObjM.valueOf(Account.AnnualRevenue)
                    .changedFromAnyToAny(new List<Integer>{ 100 }, new List<Integer>{ 101 })
                    .matches(new Account(AnnualRevenue = 101), new Account(AnnualRevenue = 100))
        );
    }

    /**
    * priorValueOf
    */

    @IsTest
    static void priorValueOf_match() {
        System.assert(
            SObjM.priorValueOf(Account.Name)
                    .equals('Old')
                    .matches(new Account(Name = 'New'), new Account(Name = 'Old'))
        );
    }

    @IsTest
    static void priorValueOf_noMatch() {
        System.assert(
            ! SObjM.priorValueOf(Account.Name)
                    .equals('Old')
                    .matches(new Account(Name = 'New'), new Account(Name = 'New'))
        );
    }

    @IsTest
    static void priorValueOf_noOldVersionProvided() {
        System.assert(
            SObjM.priorValueOf(Account.Name)
                    .equals('New')
                    .matches(new Account(Name = 'New'))
        );
    }

    /**
    * list
    */

    @IsTest
    static void matches_list() {
        List<String> names = new List<String>{ 'A', 'C' };
        SObjM.Result res = SObjM.valueOf(Account.Name)
                                .equalsAny(names)
                                .matches(new List<Account>{
                                    new Account(Name = 'A'),
                                    new Account(Name = 'B'),
                                    new Account(Name = 'C'),
                                    new Account(Name = 'D')
                                });

        System.assertEquals(2, res.hits.size());
        System.assertEquals(2, res.misses.size());

        for(Account acc : (List<Account>) res.hits) {
            System.assert(names.contains(acc.Name), acc.Name +' is not a match');
        }

        for(Account acc : (List<Account>) res.misses) {
            System.assert(! names.contains(acc.Name), acc.Name +' is not a no-match');
        }
    }

    /**
    * list (old, new)
    */

    @IsTest
    static void matches_OldNewList() {
        Account accA = new Account(Name = 'A', Id = getFakeId(Account.SObjectType));
        Account accB = new Account(Name = 'B', Id = getFakeId(Account.SObjectType));
        Account accC = new Account(Name = 'C', Id = getFakeId(Account.SObjectType));
        Account accD = new Account(Name = 'D', Id = getFakeId(Account.SObjectType));
        
        Account accAOld = accA.clone(true);
        accAOld.Name = 'A old';
        Account accBOld = accB.clone(true);
        accBOld.Name = 'B old';
        Account accCOld = accC.clone(true);
        accCOld.Name = 'C old';
        Account accDOld = accD.clone(true);
        accDOld.Name = 'D old';

        List<String> names = new List<String>{ 'A', 'C' };
        SObjM.Result res = SObjM.valueOf(Account.Name)
                                .changedToAny(names)
                                .matches(
                                    new List<Account>{ accA, accB, accC, accD },
                                    new Map<Id, Account>(new List<Account>{ accAOld, accBOld, accCOld, accDOld }));

        System.assertEquals(2, res.hits.size());
        System.assertEquals(2, res.misses.size());

        for(Account acc : (List<Account>) res.hits) {
            System.assert(names.contains(acc.Name), acc.Name +' is not a match');
        }

        for(Account acc : (List<Account>) res.misses) {
            System.assert(! names.contains(acc.Name), acc.Name +' is not a no-match');
        }
    }

    @IsTest
    static void matches_sObjectIdNull() {
        Account accNew = new Account(Name = 'A');
        Account accOld = new Account(Name = 'A', Id = getFakeId(Account.SObjectType));

        try {
            SObjM.valueOf(Account.Name).changed().matches(new List<Account>{ accNew }, new Map<Id, Account>(new List<Account>{ accOld }));
            System.assert(false, 'should throw exception');
        }
        catch(Exception e) { }
    }

    static Integer fakeIdIndex = 0;
    static Id getFakeId(SObjectType sObjType) {
        String fakeIdIndexStr = String.valueOf(fakeIdIndex++);
        return sObjType.getDescribe().getKeyPrefix() + '0'.repeat(12-fakeIdIndexStr.length()) + fakeIdIndexStr;
    }

    /**
    * string helper
    */

    @IsTest
    static void stringEquals_expectedAndActualNull() {
        System.assert(SObjM.stringEquals(null, null));
    }

    @IsTest
    static void stringEquals_expectedNull() {
        System.assert(! SObjM.stringEquals(null, 'A'));
    }

    @IsTest
    static void stringEqualsIgnoreCase_expectedAndActualNull() {
        System.assert(SObjM.stringEqualsIgnoreCase(null, null));
    }

    @IsTest
    static void stringEqualsIgnoreCase_expectedNull() {
        System.assert(! SObjM.stringEqualsIgnoreCase(null, 'A'));
    }

    @IsTest
    static void stringContains_substrNull() {
        System.assert(! SObjM.stringContains('A', null));
    }

    @IsTest
    static void stringContainsIgnoreCase_substrNull() {
        System.assert(! SObjM.stringContainsIgnoreCase('A', null));
    }

    @IsTest
    static void stringStartsWith_prefixNull() {
        System.assert(! SObjM.stringStartsWith('A', null));
    }

    @IsTest
    static void stringStartsWithIgnoreCase_prefixNull() {
        System.assert(! SObjM.stringStartsWithIgnoreCase('A', null));
    }

    @IsTest
    static void stringEndsWith_suffixNull() {
        System.assert(! SObjM.stringEndsWith('A', null));
    }

    @IsTest
    static void stringEndsWithIgnoreCase_suffixNull() {
        System.assert(! SObjM.stringEndsWithIgnoreCase('A', null));
    }

    @IsTest
    static void checkField_fieldNull() {
        try {
            SObjM.checkField(null);
            System.assert(false, 'should throw exception');
        } catch(Exception e) { }
    }

    @IsTest
    static void checkSObj_sObjectNull() {
        try {
            SObjM.checkSObj(null);
            System.assert(false, 'should throw exception');
        } catch(Exception e) { }
    }
}

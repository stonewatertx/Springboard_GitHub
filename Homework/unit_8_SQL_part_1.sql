/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you:
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1.

PART 1: PHPMyAdmin

/* QUESTIONS
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name
FROM Facilities
WHERE membercost >0

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT( name )
FROM Facilities
WHERE membercost =0

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost,monthlymaintenance
FROM Facilities
WHERE membercost < monthlymaintenance * 0.2

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM Facilities
WHERE facid IN (1,5)

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
		CASE WHEN monthlymaintenance > 100 THEN 'expensive'
				ELSE 'cheap' END AS 'fee level'
FROM Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT surname, firstname
FROM Members
WHERE joindate = (SELECT MAX(joindate) FROM Members)

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT fullname,
	CASE WHEN sum(facid)+count(facid)=1 THEN 'Tennis Court 1'
		WHEN sum(facid)+count(facid)=2 THEN 'Tennis Court 2'
		ELSE 'Tennis Court 1 & 2' END AS court

FROM (SELECT DISTINCT memid, facid FROM Bookings WHERE memid>0 AND facid IN (0,1)) AS sub1
	INNER JOIN
	 (SELECT concat(firstname,' ', surname) as fullname, memid FROM Members) AS sub2
	USING (memid)

GROUP BY fullname


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT CONCAT( firstname, ' ', surname ) AS fullname, name,
	CASE WHEN memid =0
		THEN slots * guestcost
		ELSE slots * membercost
		END AS cost
FROM Bookings
	INNER JOIN Facilities
	USING ( facid )
	JOIN Members
	USING ( memid )
WHERE starttime LIKE '2012-09-14%'
GROUP BY bookid HAVING cost > 30

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT fullname, name, cost
FROM
    (SELECT starttime, bookid, CONCAT( firstname, ' ', surname ) AS fullname, name,
    	CASE WHEN memid =0
    		THEN slots * guestcost
    		ELSE slots * membercost
    		END AS cost
    FROM Bookings
    	INNER JOIN Facilities
    	USING ( facid )
    	JOIN Members
    	USING ( memid )
    WHERE starttime LIKE '2012-09-14%') AS sub
WHERE cost>30

/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook
for the following questions.

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */


/* Q12: Find the facilities with their usage by member, but not guests */


/* Q13: Find the facilities usage by month, but not guests */

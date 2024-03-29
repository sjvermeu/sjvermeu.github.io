Title: The three additional layers in the OSI model
Date: 2021-06-09 11:10
Category: Misc
Tags: OSI,meeting,humor
Slug: the-three-additional-layers-in-the-OSI-model
Status: published

At my workplace, I jokingly refer to the three extra layers on top of the
OSI network model as a way to describe the difficulties of discussions or
cases. These three additional layers are Financial Layer, Politics Layer
and Religion Layer, and the idea is that the higher up you go, the more
challenging discussions will be.

<!-- PELICAN_END_SUMMARY -->

**Recap on the OSI model**

The Open Systems Interconnection (OSI) model is a conceptual model for
network-oriented communications, which has 7 layers - each with their own
specific peculiarities and service offerings.

The seven layers are, from top to bottom:

1. The Application Layer which provide the high-level interfaces to the
   application
2. The Presentation Layer which maps data as seen / used by an application
   to the network 
3. The Session Layer which enables continuous / conversational communication
   between nodes
4. The Transport Layer which looks at reliable transmissions between systems
5. The Network Layer which handles functions like addressing and routing
6. The Data Link Layer which looks at the interchange of frames (collection of
   bits and the interpretation of it) between two systems that are connected by
   a physical medium
7. The Physical Layer which looks at how bits are sent over the physical medium

Many network protocols can be mapped to one or more of these layers. The WiFi
standards focus on the physical and data link layers, while the IP standard
is network layer oriented. The TCP standard is strongly session and transport
layers oriented. The HTTP standard has a strong focus on the application and
presentation layer.

While the OSI model isn’t 100% applied in standards and protocols, it is
conceptually a very common way of looking at communications and network
stacks.

**OSI layers as complexity**

When I jokingly refer to the OSI model for complexity and difficulties of
discussions, it is through the assumption that the challenges rise the higher
up in the stack you go.

![The increasing complexity of discussions]({static}/images/202106/OSI_extended.png)

Discussions related to the physical aspects are often the easiest: they are about
tangible objects, people understand or at least properly observe the physical
aspects. There is little misinterpretation of the information presented to the
discussion.

Then, we start rising up the stack. Discussions that are close to the physical
aspects are still easy to moderate, but the higher up we go the more chance we
have of misinterpretation of the information at hand. People make more
assumptions to understand the discussion, which might lead to misunderstandings.

Higher layers are also because we want to abstract away the complexity of
reality. Discussions are held on topics that have wider consequences, and thus we
abstract this complexity in models so that the discussions can move forward
quickly enough. If not all people understand the abstraction (and its
consequences), the discussions might quickly move to details and specifics that
do not provide much value to the discussion, but are considered as necessary by
some of the attendees.

Even worse, the higher up we go, the more flexibility organizations expect. On
the lowest level we often have few and highly standardized choices, whereas on
higher levels we have different standards due to business units with other
requirements. The complexity rises tremendously, and we are often challenged by
stakeholders with different agendas.

The OSI model’s highest layer is the application layer, which is the layer that
covers discussions on (business) applications, which is often the level of
discussions systems architects often have to deal with. A business unit wants
solution X, but that solution isn’t compatible with the standards and enablers
that the organization already has in place. Another business unit also wants
solution X, but in a different way. And while we have solution Y in place as
well that covers 80% of the functionality… Well, you know where this is going.

Well, there are situations even worse, which make discussions and the attempts
to find a consensus even harder.

**The Financial Layer**

The first one (layer 8 so to speak) is the Financial Layer. Here the
discussions are on the economic side of things, and if you think those are
the easier discussions out there (because financials are mathematically
sound, right?) I urge you to dive deeper into this subject, because
there is plenty of work out there to simplify these discussions.

The only commonality I see with financial or economical discussions
is that they use a currency as a unit together with a time indication.
But that’s about it. Even the value of (or interpretation on) the
currency isn’t set in stone. 

Companies for instance often use internal charging for service usages.
This charging isn’t a cost that the company spends, it is mostly just
to attribute things to one business unit or the other. You might say it
is monopoly (the game) money. But that’s not always the case, as internal
charging in larger companies might also effectively reflect themselves in
the books / ledgers.

And when you are charged - regardless if it is monopoly money or not - you
tend to really try to get the best deal… even though we are talking about
chargeback and thus not actual “profits and loss” of the company. If you
force your charging to be lower, you’re forcing other’s charging to get
higher. And they don’t like that, but rather than discussing this amongst
themselves, the discussions are often pointed towards the owner of the
service and its chargeback method.

Or when project leaders make a business case (to show if a project is
beneficial from the financial side for the company) using chargeback
information. Chargeback doesn’t always (and in my opinion, mostly never)
reflect the true costs of a service, so using chargeback-currency for a
profit & loss currency is a big no-no. Yet this is oh so common still.

Even when we have the right mindset and focus on actual costs… Well,
they are hard to obtain, because actual costs are complex beasts. You’ll
find plenty of resources online about the Total Cost of Ownership (TCO),
but none of them are truly the right resource to never look at others.
TCOs are hard, you need to consider things you don’t even knew you have
to consider.

Or when you want to know just how something incurs on license costs.
Well, good luck in understanding how the vendor measures it (looking
at you, Oracle and Microsoft), or what deals your company has made with
the vendors under the umbrella of “enterprise agreements” which make all
the online resources you find useless. I had the role of license manager
for all our Oracle products for a few years, and was involved with the
Microsoft license management within my company, and it took me a while
to streamline it and communicate it properly within the organization
so all stakeholders were sufficiently aware of what it meant.

**The Politics Layer**

But financial discussions are peanuts compared with discussions that
reflect internal politics. I’m explicitly not calling this layer
strategy, although most of the discussions related to a companies’
strategy (or the strategy of the business units) are situated here
as well. It is also not governmental politics here, but the internal
domains where internal politics are reflected.

These are the discussions where you, as an architect or engineer,
come in with a presentation that covers all the ends, handles the
financial side correctly and with agreements from other architects
or engineers that the figures are sound, the solution alternatives
correctly evaluated, and the preferred solution a good balance of
all the requirements… only to find that the temperature in the room
says otherwise.

Discussions on the politics layer cover everything except what is
truly at the heart of what the discussion is about. They are about
hidden agendas that you will not be presented with at the meeting.
Many senior profiles (or, perhaps better, expert profiles) in an
organization tend to know what these hidden agendas are about, and
know how to ‘play’ and use these politics further. While their
seniority of course also focuses on the efficiency side (for instance,
a senior project leader can tackle larger projects, structure projects
better, are fluent in reporting, etc.) it is truly their organizational
experience (and sometimes ‘reading people’ skills) that makes them
quickly grow in their expertise.

The challenge is to obtain the hidden agendas and work on disentangling
the complexity of it. Hidden agendas are often based on wrong assumptions,
past emotional stress, or missing information. While you often cannot
try to attack these agendas head-first, understanding their nature can
often help in presenting cases in a way that facilitates the discussions.
You can disarm the emotional stress, or start with tackling the assumptions
that might float around.

**The Religion Layer**

Sadly, even seasoned expert profiles however come across discussions that
are not just about internal politics or people’s hidden agendas. Sometimes
discussions just take on a religious nature. This is when people are adamant
that something is true, regardless of the facts or other material that you
bring in.

Religious discussion can be found all over the place, not just on management
level. They can be about tooling, operating systems, designs, hosting choices,
etc. You all know there are people who can discuss Linux versus Windows for
ages and ages. Discussions on cloud versus on premise also often are religious
in nature. And the less time the organization allows for finding facts and
figures, the more these kinds of discussions pop up, and nobody wins on these
in the long term.

Knowing when a discussion is internal politics (and thus can still be tackled)
versus religion is hard. But once I know a discussion is no longer going to be
settled with facts, figures, and emotional/psychological approaches, then I
will be likely to try and evade those meetings. I’ll try to facilitate a
management decision (if it isn’t religious on management level either) or
just deal with the onslaught.

Challenges that are to be settled on the religion layer are no longer about
finding the optimal solution, but finding a solution or decision that is
“not in the wrong direction”. And while this is a much lower bar, it is hard
enough to reach it.


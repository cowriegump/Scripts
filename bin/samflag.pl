use strict;
 
=header
0x0001 1 the read is paired in sequencing, no matter whether it is mapped in a pair
0x0002 2 the read is mapped in a proper pair (depends on the protocol, normally inferred during alignment)
0x0004 4 the query sequence itself is unmapped
0x0008 8 the mate is unmapped
0x0010 16 strand of the query (0 for forward; 1 for reverse strand)
0x0020 32 strand of the mate
0x0040 64 the read is the ﬁrst read in a pair
0x0080 128 the read is the second read in a pair
0x0100 256 the alignment is not primary (a read having split hits may have multiple primary alignment records)
=cut

my %TABLE= qw(  0   '0'
1 '1'
2 '2'
3 '1''2'
4 '4'
5 '1''4'
6 '2''4'
7 '1''2''4'
8 '8'
9 '1''8'
10 '2''8'
11 '1''2''8'
12 '4''8'
13 '1''4''8'
14 '2''4''8'
15 '1''2''4''8'
16 '16'
17 '1''16'
18 '2''16'
19 '1''2''16'
20 '4''16'
21 '1''4''16'
22 '2''4''16'
23 '1''2''4''16'
24 '8''16'
25 '1''8''16'
26 '2''8''16'
27 '1''2''8''16'
28 '4''8''16'
29 '1''4''8''16'
30 '2''4''8''16'
31 '1''2''4''8''16'
32 '32'
33 '1''32'
34 '2''32'
35 '1''2''32'
36 '4''32'
37 '1''4''32'
38 '2''4''32'
39 '1''2''4''32'
40 '8''32'
41 '1''8''32'
42 '2''8''32'
43 '1''2''8''32'
44 '4''8''32'
45 '1''4''8''32'
46 '2''4''8''32'
47 '1''2''4''8''32'
48 '16''32'
49 '1''16''32'
50 '2''16''32'
51 '1''2''16''32'
52 '4''16''32'
53 '1''4''16''32'
54 '2''4''16''32'
55 '1''2''4''16''32'
56 '8''16''32'
57 '1''8''16''32'
58 '2''8''16''32'
59 '1''2''8''16''32'
60 '4''8''16''32'
61 '1''4''8''16''32'
62 '2''4''8''16''32'
63 '1''2''4''8''16''32'
64 '64'
65 '1''64'
66 '2''64'
67 '1''2''64'
68 '4''64'
69 '1''4''64'
70 '2''4''64'
71 '1''2''4''64'
72 '8''64'
73 '1''8''64'
74 '2''8''64'
75 '1''2''8''64'
76 '4''8''64'
77 '1''4''8''64'
78 '2''4''8''64'
79 '1''2''4''8''64'
80 '16''64'
81 '1''16''64'
82 '2''16''64'
83 '1''2''16''64'
84 '4''16''64'
85 '1''4''16''64'
86 '2''4''16''64'
87 '1''2''4''16''64'
88 '8''16''64'
89 '1''8''16''64'
90 '2''8''16''64'
91 '1''2''8''16''64'
92 '4''8''16''64'
93 '1''4''8''16''64'
94 '2''4''8''16''64'
95 '1''2''4''8''16''64'
96 '32''64'
97 '1''32''64'
98 '2''32''64'
99 '1''2''32''64'
100 '4''32''64'
101 '1''4''32''64'
102 '2''4''32''64'
103 '1''2''4''32''64'
104 '8''32''64'
105 '1''8''32''64'
106 '2''8''32''64'
107 '1''2''8''32''64'
108 '4''8''32''64'
109 '1''4''8''32''64'
110 '2''4''8''32''64'
111 '1''2''4''8''32''64'
112 '16''32''64'
113 '1''16''32''64'
114 '2''16''32''64'
115 '1''2''16''32''64'
116 '4''16''32''64'
117 '1''4''16''32''64'
118 '2''4''16''32''64'
119 '1''2''4''16''32''64'
120 '8''16''32''64'
121 '1''8''16''32''64'
122 '2''8''16''32''64'
123 '1''2''8''16''32''64'
124 '4''8''16''32''64'
125 '1''4''8''16''32''64'
126 '2''4''8''16''32''64'
127 '1''2''4''8''16''32''64'
128 '128'
129 '1''128'
130 '2''128'
131 '1''2''128'
132 '4''128'
133 '1''4''128'
134 '2''4''128'
135 '1''2''4''128'
136 '8''128'
137 '1''8''128'
138 '2''8''128'
139 '1''2''8''128'
140 '4''8''128'
141 '1''4''8''128'
142 '2''4''8''128'
143 '1''2''4''8''128'
144 '16''128'
145 '1''16''128'
146 '2''16''128'
147 '1''2''16''128'
148 '4''16''128'
149 '1''4''16''128'
150 '2''4''16''128'
151 '1''2''4''16''128'
152 '8''16''128'
153 '1''8''16''128'
154 '2''8''16''128'
155 '1''2''8''16''128'
156 '4''8''16''128'
157 '1''4''8''16''128'
158 '2''4''8''16''128'
159 '1''2''4''8''16''128'
160 '32''128'
161 '1''32''128'
162 '2''32''128'
163 '1''2''32''128'
164 '4''32''128'
165 '1''4''32''128'
166 '2''4''32''128'
167 '1''2''4''32''128'
168 '8''32''128'
169 '1''8''32''128'
170 '2''8''32''128'
171 '1''2''8''32''128'
172 '4''8''32''128'
173 '1''4''8''32''128'
174 '2''4''8''32''128'
175 '1''2''4''8''32''128'
176 '16''32''128'
177 '1''16''32''128'
178 '2''16''32''128'
179 '1''2''16''32''128'
180 '4''16''32''128'
181 '1''4''16''32''128'
182 '2''4''16''32''128'
183 '1''2''4''16''32''128'
184 '8''16''32''128'
185 '1''8''16''32''128'
186 '2''8''16''32''128'
187 '1''2''8''16''32''128'
188 '4''8''16''32''128'
189 '1''4''8''16''32''128'
190 '2''4''8''16''32''128'
191 '1''2''4''8''16''32''128'
192 '64''128'
193 '1''64''128'
194 '2''64''128'
195 '1''2''64''128'
196 '4''64''128'
197 '1''4''64''128'
198 '2''4''64''128'
199 '1''2''4''64''128'
200 '8''64''128'
201 '1''8''64''128'
202 '2''8''64''128'
203 '1''2''8''64''128'
204 '4''8''64''128'
205 '1''4''8''64''128'
206 '2''4''8''64''128'
207 '1''2''4''8''64''128'
208 '16''64''128'
209 '1''16''64''128'
210 '2''16''64''128'
211 '1''2''16''64''128'
212 '4''16''64''128'
213 '1''4''16''64''128'
214 '2''4''16''64''128'
215 '1''2''4''16''64''128'
216 '8''16''64''128'
217 '1''8''16''64''128'
218 '2''8''16''64''128'
219 '1''2''8''16''64''128'
220 '4''8''16''64''128'
221 '1''4''8''16''64''128'
222 '2''4''8''16''64''128'
223 '1''2''4''8''16''64''128'
224 '32''64''128'
225 '1''32''64''128'
226 '2''32''64''128'
227 '1''2''32''64''128'
228 '4''32''64''128'
229 '1''4''32''64''128'
230 '2''4''32''64''128'
231 '1''2''4''32''64''128'
232 '8''32''64''128'
233 '1''8''32''64''128'
234 '2''8''32''64''128'
235 '1''2''8''32''64''128'
236 '4''8''32''64''128'
237 '1''4''8''32''64''128'
238 '2''4''8''32''64''128'
239 '1''2''4''8''32''64''128'
240 '16''32''64''128'
241 '1''16''32''64''128'
242 '2''16''32''64''128'
243 '1''2''16''32''64''128'
244 '4''16''32''64''128'
245 '1''4''16''32''64''128'
246 '2''4''16''32''64''128'
247 '1''2''4''16''32''64''128'
248 '8''16''32''64''128'
249 '1''8''16''32''64''128'
250 '2''8''16''32''64''128'
251 '1''2''8''16''32''64''128'
252 '4''8''16''32''64''128'
253 '1''4''8''16''32''64''128'
254 '2''4''8''16''32''64''128'
255 '1''2''4''8''16''32''64''128');




my %TABLE=
qw(0   0
 1   1
 2   2
 3   1+2
 4   0+4
 5   1+4
 6   0+2+4
 7   1+2+4
 8   0+8
 9   1+8
 10   0+2+8
 11   1+2+8
 12   0+4+8
 13   1+4+8
 14   0+2+4+8
 15   1+2+4+8
 16   0+16
 17   1+16
 18   0+2+16
 19   1+2+16
 20   0+4+16
 21   1+4+16
 22   0+2+4+16
 23   1+2+4+16
 24   0+8+16
 25   1+8+16
 26   0+2+8+16
 27   1+2+8+16
 28   0+4+8+16
 29   1+4+8+16
 30   0+2+4+8+16
 31   1+2+4+8+16
 32   0+32
 33   1+32
 34   0+2+32
 35   1+2+32
 36   0+4+32
 37   1+4+32
 38   0+2+4+32
 39   1+2+4+32
 40   0+8+32
 41   1+8+32
 42   0+2+8+32
 43   1+2+8+32
 44   0+4+8+32
 45   1+4+8+32
 46   0+2+4+8+32
 47   1+2+4+8+32
 48   0+16+32
 49   1+16+32
 50   0+2+16+32
 51   1+2+16+32
 52   0+4+16+32
 53   1+4+16+32
 54   0+2+4+16+32
 55   1+2+4+16+32
 56   0+8+16+32
 57   1+8+16+32
 58   0+2+8+16+32
 59   1+2+8+16+32
 60   0+4+8+16+32
 61   1+4+8+16+32
 62   0+2+4+8+16+32
 63   1+2+4+8+16+32
 64   0+64
 65   1+64
 66   0+2+64
 67   1+2+64
 68   0+4+64
 69   1+4+64
 70   0+2+4+64
 71   1+2+4+64
 72   0+8+64
 73   1+8+64
 74   0+2+8+64
 75   1+2+8+64
 76   0+4+8+64
 77   1+4+8+64
 78   0+2+4+8+64
 79   1+2+4+8+64
 80   0+16+64
 81   1+16+64
 82   0+2+16+64
 83   1+2+16+64
 84   0+4+16+64
 85   1+4+16+64
 86   0+2+4+16+64
 87   1+2+4+16+64
 88   0+8+16+64
 89   1+8+16+64
 90   0+2+8+16+64
 91   1+2+8+16+64
 92   0+4+8+16+64
 93   1+4+8+16+64
 94   0+2+4+8+16+64
 95   1+2+4+8+16+64
 96   0+32+64
 97   1+32+64
 98   0+2+32+64
 99   1+2+32+64
 100   0+4+32+64
 101   1+4+32+64
 102   0+2+4+32+64
 103   1+2+4+32+64
 104   0+8+32+64
 105   1+8+32+64
 106   0+2+8+32+64
 107   1+2+8+32+64
 108   0+4+8+32+64
 109   1+4+8+32+64
 110   0+2+4+8+32+64
 111   1+2+4+8+32+64
 112   0+16+32+64
 113   1+16+32+64
 114   0+2+16+32+64
 115   1+2+16+32+64
 116   0+4+16+32+64
 117   1+4+16+32+64
 118   0+2+4+16+32+64
 119   1+2+4+16+32+64
 120   0+8+16+32+64
 121   1+8+16+32+64
 122   0+2+8+16+32+64
 123   1+2+8+16+32+64
 124   0+4+8+16+32+64
 125   1+4+8+16+32+64
 126   0+2+4+8+16+32+64
 127   1+2+4+8+16+32+64
 128   0+128
 129   1+128
 130   0+2+128
 131   1+2+128
 132   0+4+128
 133   1+4+128
 134   0+2+4+128
 135   1+2+4+128
 136   0+8+128
 137   1+8+128
 138   0+2+8+128
 139   1+2+8+128
 140   0+4+8+128
 141   1+4+8+128
 142   0+2+4+8+128
 143   1+2+4+8+128
 144   0+16+128
 145   1+16+128
 146   0+2+16+128
 147   1+2+16+128
 148   0+4+16+128
 149   1+4+16+128
 150   0+2+4+16+128
 151   1+2+4+16+128
 152   0+8+16+128
 153   1+8+16+128
 154   0+2+8+16+128
 155   1+2+8+16+128
 156   0+4+8+16+128
 157   1+4+8+16+128
 158   0+2+4+8+16+128
 159   1+2+4+8+16+128
 160   0+32+128
 161   1+32+128
 162   0+2+32+128
 163   1+2+32+128
 164   0+4+32+128
 165   1+4+32+128
 166   0+2+4+32+128
 167   1+2+4+32+128
 168   0+8+32+128
 169   1+8+32+128
 170   0+2+8+32+128
 171   1+2+8+32+128
 172   0+4+8+32+128
 173   1+4+8+32+128
 174   0+2+4+8+32+128
 175   1+2+4+8+32+128
 176   0+16+32+128
 177   1+16+32+128
 178   0+2+16+32+128
 179   1+2+16+32+128
 180   0+4+16+32+128
 181   1+4+16+32+128
 182   0+2+4+16+32+128
 183   1+2+4+16+32+128
 184   0+8+16+32+128
 185   1+8+16+32+128
 186   0+2+8+16+32+128
 187   1+2+8+16+32+128
 188   0+4+8+16+32+128
 189   1+4+8+16+32+128
 190   0+2+4+8+16+32+128
 191   1+2+4+8+16+32+128
 192   0+64+128
 193   1+64+128
 194   0+2+64+128
 195   1+2+64+128
 196   0+4+64+128
 197   1+4+64+128
 198   0+2+4+64+128
 199   1+2+4+64+128
 200   0+8+64+128
 201   1+8+64+128
 202   0+2+8+64+128
 203   1+2+8+64+128
 204   0+4+8+64+128
 205   1+4+8+64+128
 206   0+2+4+8+64+128
 207   1+2+4+8+64+128
 208   0+16+64+128
 209   1+16+64+128
 210   0+2+16+64+128
 211   1+2+16+64+128
 212   0+4+16+64+128
 213   1+4+16+64+128
 214   0+2+4+16+64+128
 215   1+2+4+16+64+128
 216   0+8+16+64+128
 217   1+8+16+64+128
 218   0+2+8+16+64+128
 219   1+2+8+16+64+128
 220   0+4+8+16+64+128
 221   1+4+8+16+64+128
 222   0+2+4+8+16+64+128
 223   1+2+4+8+16+64+128
 224   0+32+64+128
 225   1+32+64+128
 226   0+2+32+64+128
 227   1+2+32+64+128
 228   0+4+32+64+128
 229   1+4+32+64+128
 230   0+2+4+32+64+128
 231   1+2+4+32+64+128
 232   0+8+32+64+128
 233   1+8+32+64+128
 234   0+2+8+32+64+128
 235   1+2+8+32+64+128
 236   0+4+8+32+64+128
 237   1+4+8+32+64+128
 238   0+2+4+8+32+64+128
 239   1+2+4+8+32+64+128
 240   0+16+32+64+128
 241   1+16+32+64+128
 242   0+2+16+32+64+128
 243   1+2+16+32+64+128
 244   0+4+16+32+64+128
 245   1+4+16+32+64+128
 246   0+2+4+16+32+64+128
 247   1+2+4+16+32+64+128
 248   0+8+16+32+64+128
 249   1+8+16+32+64+128
 250   0+2+8+16+32+64+128
 251   1+2+8+16+32+64+128
 252   0+4+8+16+32+64+128
 253   1+4+8+16+32+64+128
 254   0+2+4+8+16+32+64+128
 255   1+2+4+8+16+32+64+128);


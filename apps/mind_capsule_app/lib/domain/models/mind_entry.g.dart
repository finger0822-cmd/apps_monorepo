// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mind_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMindEntryCollection on Isar {
  IsarCollection<MindEntry> get mindEntrys => this.collection();
}

const MindEntrySchema = CollectionSchema(
  name: r'MindEntry',
  id: 1640414599102568753,
  properties: {
    r'aiComparison': PropertySchema(
      id: 0,
      name: r'aiComparison',
      type: IsarType.string,
    ),
    r'aiComparisonLoaded': PropertySchema(
      id: 1,
      name: r'aiComparisonLoaded',
      type: IsarType.bool,
    ),
    r'aiFeedback': PropertySchema(
      id: 2,
      name: r'aiFeedback',
      type: IsarType.string,
    ),
    r'aiFeedbackLoaded': PropertySchema(
      id: 3,
      name: r'aiFeedbackLoaded',
      type: IsarType.bool,
    ),
    r'averageScore': PropertySchema(
      id: 4,
      name: r'averageScore',
      type: IsarType.double,
    ),
    r'capsuleNote': PropertySchema(
      id: 5,
      name: r'capsuleNote',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 6,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'energy': PropertySchema(
      id: 7,
      name: r'energy',
      type: IsarType.long,
    ),
    r'fatigue': PropertySchema(
      id: 8,
      name: r'fatigue',
      type: IsarType.long,
    ),
    r'focus': PropertySchema(
      id: 9,
      name: r'focus',
      type: IsarType.long,
    ),
    r'isOpened': PropertySchema(
      id: 10,
      name: r'isOpened',
      type: IsarType.bool,
    ),
    r'isSealed': PropertySchema(
      id: 11,
      name: r'isSealed',
      type: IsarType.bool,
    ),
    r'isTimeCapsule': PropertySchema(
      id: 12,
      name: r'isTimeCapsule',
      type: IsarType.bool,
    ),
    r'mood': PropertySchema(
      id: 13,
      name: r'mood',
      type: IsarType.long,
    ),
    r'openOn': PropertySchema(
      id: 14,
      name: r'openOn',
      type: IsarType.dateTime,
    ),
    r'openedAt': PropertySchema(
      id: 15,
      name: r'openedAt',
      type: IsarType.dateTime,
    ),
    r'sleepiness': PropertySchema(
      id: 16,
      name: r'sleepiness',
      type: IsarType.long,
    ),
    r'text': PropertySchema(
      id: 17,
      name: r'text',
      type: IsarType.string,
    )
  },
  estimateSize: _mindEntryEstimateSize,
  serialize: _mindEntrySerialize,
  deserialize: _mindEntryDeserialize,
  deserializeProp: _mindEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _mindEntryGetId,
  getLinks: _mindEntryGetLinks,
  attach: _mindEntryAttach,
  version: '3.1.0+1',
);

int _mindEntryEstimateSize(
  MindEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.aiComparison;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.aiFeedback;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.capsuleNote;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.text.length * 3;
  return bytesCount;
}

void _mindEntrySerialize(
  MindEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.aiComparison);
  writer.writeBool(offsets[1], object.aiComparisonLoaded);
  writer.writeString(offsets[2], object.aiFeedback);
  writer.writeBool(offsets[3], object.aiFeedbackLoaded);
  writer.writeDouble(offsets[4], object.averageScore);
  writer.writeString(offsets[5], object.capsuleNote);
  writer.writeDateTime(offsets[6], object.createdAt);
  writer.writeLong(offsets[7], object.energy);
  writer.writeLong(offsets[8], object.fatigue);
  writer.writeLong(offsets[9], object.focus);
  writer.writeBool(offsets[10], object.isOpened);
  writer.writeBool(offsets[11], object.isSealed);
  writer.writeBool(offsets[12], object.isTimeCapsule);
  writer.writeLong(offsets[13], object.mood);
  writer.writeDateTime(offsets[14], object.openOn);
  writer.writeDateTime(offsets[15], object.openedAt);
  writer.writeLong(offsets[16], object.sleepiness);
  writer.writeString(offsets[17], object.text);
}

MindEntry _mindEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MindEntry(
    aiComparison: reader.readStringOrNull(offsets[0]),
    aiComparisonLoaded: reader.readBoolOrNull(offsets[1]) ?? false,
    aiFeedback: reader.readStringOrNull(offsets[2]),
    aiFeedbackLoaded: reader.readBoolOrNull(offsets[3]) ?? false,
    capsuleNote: reader.readStringOrNull(offsets[5]),
    createdAt: reader.readDateTime(offsets[6]),
    energy: reader.readLong(offsets[7]),
    fatigue: reader.readLong(offsets[8]),
    focus: reader.readLong(offsets[9]),
    mood: reader.readLong(offsets[13]),
    openOn: reader.readDateTimeOrNull(offsets[14]),
    openedAt: reader.readDateTimeOrNull(offsets[15]),
    sleepiness: reader.readLong(offsets[16]),
    text: reader.readString(offsets[17]),
  );
  object.id = id;
  return object;
}

P _mindEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 15:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mindEntryGetId(MindEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mindEntryGetLinks(MindEntry object) {
  return [];
}

void _mindEntryAttach(IsarCollection<dynamic> col, Id id, MindEntry object) {
  object.id = id;
}

extension MindEntryQueryWhereSort
    on QueryBuilder<MindEntry, MindEntry, QWhere> {
  QueryBuilder<MindEntry, MindEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension MindEntryQueryWhere
    on QueryBuilder<MindEntry, MindEntry, QWhereClause> {
  QueryBuilder<MindEntry, MindEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterWhereClause> createdAtEqualTo(
      DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterWhereClause> createdAtNotEqualTo(
      DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterWhereClause> createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterWhereClause> createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterWhereClause> createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MindEntryQueryFilter
    on QueryBuilder<MindEntry, MindEntry, QFilterCondition> {
  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiComparisonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'aiComparison',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiComparisonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'aiComparison',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> aiComparisonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiComparison',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiComparisonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aiComparison',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiComparisonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aiComparison',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> aiComparisonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aiComparison',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiComparisonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aiComparison',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiComparisonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aiComparison',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiComparisonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aiComparison',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> aiComparisonMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aiComparison',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiComparisonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiComparison',
        value: '',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiComparisonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aiComparison',
        value: '',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiComparisonLoadedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiComparisonLoaded',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> aiFeedbackIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'aiFeedback',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiFeedbackIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'aiFeedback',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> aiFeedbackEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiFeedback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiFeedbackGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aiFeedback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> aiFeedbackLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aiFeedback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> aiFeedbackBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aiFeedback',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiFeedbackStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aiFeedback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> aiFeedbackEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aiFeedback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> aiFeedbackContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aiFeedback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> aiFeedbackMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aiFeedback',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiFeedbackIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiFeedback',
        value: '',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiFeedbackIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aiFeedback',
        value: '',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      aiFeedbackLoadedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiFeedbackLoaded',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> averageScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      averageScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      averageScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> averageScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      capsuleNoteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'capsuleNote',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      capsuleNoteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'capsuleNote',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> capsuleNoteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capsuleNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      capsuleNoteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'capsuleNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> capsuleNoteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'capsuleNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> capsuleNoteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'capsuleNote',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      capsuleNoteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'capsuleNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> capsuleNoteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'capsuleNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> capsuleNoteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'capsuleNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> capsuleNoteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'capsuleNote',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      capsuleNoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capsuleNote',
        value: '',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      capsuleNoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'capsuleNote',
        value: '',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> energyEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'energy',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> energyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'energy',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> energyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'energy',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> energyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'energy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> fatigueEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fatigue',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> fatigueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fatigue',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> fatigueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fatigue',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> fatigueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fatigue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> focusEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'focus',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> focusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'focus',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> focusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'focus',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> focusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'focus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> isOpenedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOpened',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> isSealedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSealed',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      isTimeCapsuleEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isTimeCapsule',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> moodEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mood',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> moodGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mood',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> moodLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mood',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> moodBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mood',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> openOnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'openOn',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> openOnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'openOn',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> openOnEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'openOn',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> openOnGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'openOn',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> openOnLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'openOn',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> openOnBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'openOn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> openedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'openedAt',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      openedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'openedAt',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> openedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'openedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> openedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'openedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> openedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'openedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> openedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'openedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> sleepinessEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sleepiness',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition>
      sleepinessGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sleepiness',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> sleepinessLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sleepiness',
        value: value,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> sleepinessBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sleepiness',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> textContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> textMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterFilterCondition> textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }
}

extension MindEntryQueryObject
    on QueryBuilder<MindEntry, MindEntry, QFilterCondition> {}

extension MindEntryQueryLinks
    on QueryBuilder<MindEntry, MindEntry, QFilterCondition> {}

extension MindEntryQuerySortBy on QueryBuilder<MindEntry, MindEntry, QSortBy> {
  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByAiComparison() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiComparison', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByAiComparisonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiComparison', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByAiComparisonLoaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiComparisonLoaded', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy>
      sortByAiComparisonLoadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiComparisonLoaded', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByAiFeedback() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedback', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByAiFeedbackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedback', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByAiFeedbackLoaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedbackLoaded', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy>
      sortByAiFeedbackLoadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedbackLoaded', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByAverageScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageScore', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByAverageScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageScore', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByCapsuleNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capsuleNote', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByCapsuleNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capsuleNote', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByEnergy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByEnergyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByFatigue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigue', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByFatigueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigue', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focus', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByFocusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focus', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByIsOpened() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpened', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByIsOpenedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpened', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByIsSealed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSealed', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByIsSealedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSealed', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByIsTimeCapsule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTimeCapsule', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByIsTimeCapsuleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTimeCapsule', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByOpenOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openOn', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByOpenOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openOn', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByOpenedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortBySleepiness() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepiness', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortBySleepinessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepiness', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension MindEntryQuerySortThenBy
    on QueryBuilder<MindEntry, MindEntry, QSortThenBy> {
  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByAiComparison() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiComparison', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByAiComparisonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiComparison', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByAiComparisonLoaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiComparisonLoaded', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy>
      thenByAiComparisonLoadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiComparisonLoaded', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByAiFeedback() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedback', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByAiFeedbackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedback', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByAiFeedbackLoaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedbackLoaded', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy>
      thenByAiFeedbackLoadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedbackLoaded', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByAverageScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageScore', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByAverageScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageScore', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByCapsuleNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capsuleNote', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByCapsuleNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capsuleNote', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByEnergy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByEnergyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByFatigue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigue', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByFatigueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigue', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focus', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByFocusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focus', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByIsOpened() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpened', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByIsOpenedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpened', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByIsSealed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSealed', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByIsSealedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSealed', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByIsTimeCapsule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTimeCapsule', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByIsTimeCapsuleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTimeCapsule', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByOpenOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openOn', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByOpenOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openOn', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByOpenedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenBySleepiness() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepiness', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenBySleepinessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepiness', Sort.desc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension MindEntryQueryWhereDistinct
    on QueryBuilder<MindEntry, MindEntry, QDistinct> {
  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByAiComparison(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aiComparison', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByAiComparisonLoaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aiComparisonLoaded');
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByAiFeedback(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aiFeedback', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByAiFeedbackLoaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aiFeedbackLoaded');
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByAverageScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageScore');
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByCapsuleNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'capsuleNote', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByEnergy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'energy');
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByFatigue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fatigue');
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focus');
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByIsOpened() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOpened');
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByIsSealed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSealed');
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByIsTimeCapsule() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isTimeCapsule');
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mood');
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByOpenOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openOn');
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openedAt');
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctBySleepiness() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sleepiness');
    });
  }

  QueryBuilder<MindEntry, MindEntry, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }
}

extension MindEntryQueryProperty
    on QueryBuilder<MindEntry, MindEntry, QQueryProperty> {
  QueryBuilder<MindEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MindEntry, String?, QQueryOperations> aiComparisonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aiComparison');
    });
  }

  QueryBuilder<MindEntry, bool, QQueryOperations> aiComparisonLoadedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aiComparisonLoaded');
    });
  }

  QueryBuilder<MindEntry, String?, QQueryOperations> aiFeedbackProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aiFeedback');
    });
  }

  QueryBuilder<MindEntry, bool, QQueryOperations> aiFeedbackLoadedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aiFeedbackLoaded');
    });
  }

  QueryBuilder<MindEntry, double, QQueryOperations> averageScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageScore');
    });
  }

  QueryBuilder<MindEntry, String?, QQueryOperations> capsuleNoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'capsuleNote');
    });
  }

  QueryBuilder<MindEntry, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MindEntry, int, QQueryOperations> energyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'energy');
    });
  }

  QueryBuilder<MindEntry, int, QQueryOperations> fatigueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fatigue');
    });
  }

  QueryBuilder<MindEntry, int, QQueryOperations> focusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focus');
    });
  }

  QueryBuilder<MindEntry, bool, QQueryOperations> isOpenedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOpened');
    });
  }

  QueryBuilder<MindEntry, bool, QQueryOperations> isSealedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSealed');
    });
  }

  QueryBuilder<MindEntry, bool, QQueryOperations> isTimeCapsuleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isTimeCapsule');
    });
  }

  QueryBuilder<MindEntry, int, QQueryOperations> moodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mood');
    });
  }

  QueryBuilder<MindEntry, DateTime?, QQueryOperations> openOnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openOn');
    });
  }

  QueryBuilder<MindEntry, DateTime?, QQueryOperations> openedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openedAt');
    });
  }

  QueryBuilder<MindEntry, int, QQueryOperations> sleepinessProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sleepiness');
    });
  }

  QueryBuilder<MindEntry, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }
}

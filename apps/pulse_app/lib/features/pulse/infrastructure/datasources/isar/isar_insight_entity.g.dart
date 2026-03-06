// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_insight_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarInsightEntityCollection on Isar {
  IsarCollection<IsarInsightEntity> get isarInsightEntitys => this.collection();
}

const IsarInsightEntitySchema = CollectionSchema(
  name: r'IsarInsightEntity',
  id: -18896552274058829,
  properties: {
    r'bulletsJson': PropertySchema(
      id: 0,
      name: r'bulletsJson',
      type: IsarType.string,
    ),
    r'createdAtUtcIso': PropertySchema(
      id: 1,
      name: r'createdAtUtcIso',
      type: IsarType.string,
    ),
    r'insightId': PropertySchema(
      id: 2,
      name: r'insightId',
      type: IsarType.string,
    ),
    r'model': PropertySchema(
      id: 3,
      name: r'model',
      type: IsarType.string,
    ),
    r'promptVersion': PropertySchema(
      id: 4,
      name: r'promptVersion',
      type: IsarType.long,
    ),
    r'rangeKey': PropertySchema(
      id: 5,
      name: r'rangeKey',
      type: IsarType.string,
    ),
    r'summaryText': PropertySchema(
      id: 6,
      name: r'summaryText',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(
      id: 7,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _isarInsightEntityEstimateSize,
  serialize: _isarInsightEntitySerialize,
  deserialize: _isarInsightEntityDeserialize,
  deserializeProp: _isarInsightEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'insightId': IndexSchema(
      id: 5818887354909674719,
      name: r'insightId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'insightId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'rangeKey': IndexSchema(
      id: 5155789477146519493,
      name: r'rangeKey',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'rangeKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarInsightEntityGetId,
  getLinks: _isarInsightEntityGetLinks,
  attach: _isarInsightEntityAttach,
  version: '3.1.0+1',
);

int _isarInsightEntityEstimateSize(
  IsarInsightEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bulletsJson.length * 3;
  bytesCount += 3 + object.createdAtUtcIso.length * 3;
  bytesCount += 3 + object.insightId.length * 3;
  bytesCount += 3 + object.model.length * 3;
  bytesCount += 3 + object.rangeKey.length * 3;
  bytesCount += 3 + object.summaryText.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _isarInsightEntitySerialize(
  IsarInsightEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bulletsJson);
  writer.writeString(offsets[1], object.createdAtUtcIso);
  writer.writeString(offsets[2], object.insightId);
  writer.writeString(offsets[3], object.model);
  writer.writeLong(offsets[4], object.promptVersion);
  writer.writeString(offsets[5], object.rangeKey);
  writer.writeString(offsets[6], object.summaryText);
  writer.writeString(offsets[7], object.userId);
}

IsarInsightEntity _isarInsightEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarInsightEntity();
  object.bulletsJson = reader.readString(offsets[0]);
  object.createdAtUtcIso = reader.readString(offsets[1]);
  object.id = id;
  object.insightId = reader.readString(offsets[2]);
  object.model = reader.readString(offsets[3]);
  object.promptVersion = reader.readLong(offsets[4]);
  object.rangeKey = reader.readString(offsets[5]);
  object.summaryText = reader.readString(offsets[6]);
  object.userId = reader.readString(offsets[7]);
  return object;
}

P _isarInsightEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarInsightEntityGetId(IsarInsightEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarInsightEntityGetLinks(
    IsarInsightEntity object) {
  return [];
}

void _isarInsightEntityAttach(
    IsarCollection<dynamic> col, Id id, IsarInsightEntity object) {
  object.id = id;
}

extension IsarInsightEntityByIndex on IsarCollection<IsarInsightEntity> {
  Future<IsarInsightEntity?> getByInsightId(String insightId) {
    return getByIndex(r'insightId', [insightId]);
  }

  IsarInsightEntity? getByInsightIdSync(String insightId) {
    return getByIndexSync(r'insightId', [insightId]);
  }

  Future<bool> deleteByInsightId(String insightId) {
    return deleteByIndex(r'insightId', [insightId]);
  }

  bool deleteByInsightIdSync(String insightId) {
    return deleteByIndexSync(r'insightId', [insightId]);
  }

  Future<List<IsarInsightEntity?>> getAllByInsightId(
      List<String> insightIdValues) {
    final values = insightIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'insightId', values);
  }

  List<IsarInsightEntity?> getAllByInsightIdSync(List<String> insightIdValues) {
    final values = insightIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'insightId', values);
  }

  Future<int> deleteAllByInsightId(List<String> insightIdValues) {
    final values = insightIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'insightId', values);
  }

  int deleteAllByInsightIdSync(List<String> insightIdValues) {
    final values = insightIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'insightId', values);
  }

  Future<Id> putByInsightId(IsarInsightEntity object) {
    return putByIndex(r'insightId', object);
  }

  Id putByInsightIdSync(IsarInsightEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'insightId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInsightId(List<IsarInsightEntity> objects) {
    return putAllByIndex(r'insightId', objects);
  }

  List<Id> putAllByInsightIdSync(List<IsarInsightEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'insightId', objects, saveLinks: saveLinks);
  }
}

extension IsarInsightEntityQueryWhereSort
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QWhere> {
  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarInsightEntityQueryWhere
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QWhereClause> {
  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      insightIdEqualTo(String insightId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'insightId',
        value: [insightId],
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      insightIdNotEqualTo(String insightId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insightId',
              lower: [],
              upper: [insightId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insightId',
              lower: [insightId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insightId',
              lower: [insightId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insightId',
              lower: [],
              upper: [insightId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      userIdNotEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      rangeKeyEqualTo(String rangeKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'rangeKey',
        value: [rangeKey],
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      rangeKeyNotEqualTo(String rangeKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rangeKey',
              lower: [],
              upper: [rangeKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rangeKey',
              lower: [rangeKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rangeKey',
              lower: [rangeKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rangeKey',
              lower: [],
              upper: [rangeKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarInsightEntityQueryFilter
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QFilterCondition> {
  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      bulletsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bulletsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      bulletsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bulletsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      bulletsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bulletsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      bulletsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bulletsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      bulletsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bulletsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      bulletsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bulletsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      bulletsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bulletsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      bulletsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bulletsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      bulletsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bulletsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      bulletsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bulletsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      createdAtUtcIsoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAtUtcIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      createdAtUtcIsoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAtUtcIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      createdAtUtcIsoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAtUtcIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      createdAtUtcIsoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAtUtcIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      createdAtUtcIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createdAtUtcIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      createdAtUtcIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createdAtUtcIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      createdAtUtcIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdAtUtcIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      createdAtUtcIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdAtUtcIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      createdAtUtcIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAtUtcIso',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      createdAtUtcIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdAtUtcIso',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'insightId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'insightId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'insightId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'insightId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'insightId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'insightId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'insightId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'insightId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'insightId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'insightId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      modelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      modelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      modelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      modelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'model',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      modelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      modelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      modelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      modelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'model',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      modelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      modelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      promptVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'promptVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      promptVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'promptVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      promptVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'promptVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      promptVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'promptVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      rangeKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rangeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      rangeKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rangeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      rangeKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rangeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      rangeKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rangeKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      rangeKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rangeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      rangeKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rangeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      rangeKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rangeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      rangeKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rangeKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      rangeKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rangeKey',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      rangeKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rangeKey',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summaryText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'summaryText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'summaryText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'summaryText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'summaryText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'summaryText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'summaryText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'summaryText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summaryText',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'summaryText',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension IsarInsightEntityQueryObject
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QFilterCondition> {}

extension IsarInsightEntityQueryLinks
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QFilterCondition> {}

extension IsarInsightEntityQuerySortBy
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QSortBy> {
  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByBulletsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bulletsJson', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByBulletsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bulletsJson', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByCreatedAtUtcIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtcIso', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByCreatedAtUtcIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtcIso', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByInsightId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightId', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByInsightIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightId', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByPromptVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptVersion', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByPromptVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptVersion', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByRangeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rangeKey', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByRangeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rangeKey', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortBySummaryText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryText', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortBySummaryTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryText', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension IsarInsightEntityQuerySortThenBy
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QSortThenBy> {
  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByBulletsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bulletsJson', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByBulletsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bulletsJson', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByCreatedAtUtcIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtcIso', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByCreatedAtUtcIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtcIso', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByInsightId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightId', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByInsightIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightId', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByPromptVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptVersion', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByPromptVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptVersion', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByRangeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rangeKey', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByRangeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rangeKey', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenBySummaryText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryText', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenBySummaryTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryText', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension IsarInsightEntityQueryWhereDistinct
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct> {
  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct>
      distinctByBulletsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bulletsJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct>
      distinctByCreatedAtUtcIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAtUtcIso',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct>
      distinctByInsightId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'insightId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct> distinctByModel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'model', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct>
      distinctByPromptVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'promptVersion');
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct>
      distinctByRangeKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rangeKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct>
      distinctBySummaryText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'summaryText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension IsarInsightEntityQueryProperty
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QQueryProperty> {
  QueryBuilder<IsarInsightEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarInsightEntity, String, QQueryOperations>
      bulletsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bulletsJson');
    });
  }

  QueryBuilder<IsarInsightEntity, String, QQueryOperations>
      createdAtUtcIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAtUtcIso');
    });
  }

  QueryBuilder<IsarInsightEntity, String, QQueryOperations>
      insightIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'insightId');
    });
  }

  QueryBuilder<IsarInsightEntity, String, QQueryOperations> modelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'model');
    });
  }

  QueryBuilder<IsarInsightEntity, int, QQueryOperations>
      promptVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'promptVersion');
    });
  }

  QueryBuilder<IsarInsightEntity, String, QQueryOperations> rangeKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rangeKey');
    });
  }

  QueryBuilder<IsarInsightEntity, String, QQueryOperations>
      summaryTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'summaryText');
    });
  }

  QueryBuilder<IsarInsightEntity, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}

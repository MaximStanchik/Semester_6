module.exports = (sequelize, DataTypes) => {
    const Teacher = sequelize.define('Teacher', {
        teacher: { type: DataTypes.STRING, primaryKey: true },
        name: DataTypes.STRING,
        pulpit: DataTypes.STRING,
    }, {
        timestamps: false,
        freezeTableName: true,  
        tableName: 'Teacher'
    });

    Teacher.associate = models => {
        Teacher.belongsTo(models.Pulpit, { foreignKey: 'pulpit', targetKey: 'pulpit' });
    };

    return Teacher;
};

module.exports = (sequelize, DataTypes) => {
    const Subject = sequelize.define('Subject', {
        subject: { type: DataTypes.STRING, primaryKey: true },
        name: DataTypes.STRING,
        pulpit: DataTypes.STRING,
    }, {
        timestamps: false,
        freezeTableName: true,  
        tableName: 'Subject'    
    });

    Subject.associate = models => {
        Subject.belongsTo(models.Pulpit, { foreignKey: 'pulpit', targetKey: 'pulpit' });
    };

    return Subject;
};

 
//  CoreDataManager.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataManager : NSObject
/**
 * 单例模式
 * 参数:NO
 * 返回值:CoreDataManager
 * author:DCQ
 *
 */
+ (CoreDataManager *)shareCoreDataManagerManager;

/**
 * 创建空的表映射对象
 * 参数:实体描述名
 * 返回值:id
 * author:DCQ
 *
 */
- (id)createEmptyObjectWithEntityName:(NSString *)entityName;
/**
 * 查询托管对象上下文中的对象
 * 参数:(查询条件,排序条件,返回总个数)
 * 返回值:NSArray
 * author:DCQ
 *
 */
- (NSArray *)getListWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptions entityName:(NSString *)entityName limitNum:(NSNumber *)limitNum;



/**
 * 删除托管对象上下文中的一个对象
 * 参数:需要删除的任意对象
 * 返回值:void
 * author:DCQ
 *
 */
- (void)deleteObject:(NSManagedObject *)object;


/**
 * 删除托管对象上下文中的所有对象
 * 参数:实体描述名
 * 返回值:void
 * author:DCQ
 *
 */
- (void)removeAllObjectWithEntityName:(NSString *)entityName;

/**
 * 保存托管对象上下文中的更改
 * 参数:NO
 * 返回值:BOOL
 * author:DCQ
 *
 */
- (BOOL)save;
@end
